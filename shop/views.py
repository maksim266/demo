from django.shortcuts import render, redirect, get_object_or_404
from django.http import HttpResponseForbidden
from django.contrib import messages
from .models import User, Product, Category, Manufacturer, Supplier, Unit, OrderItem
from django.db.models import Q
import os
from PIL import Image
from django.conf import settings


def login_view(request):
    """Окно входа в систему"""
    if request.method == 'POST':
        login = request.POST.get('login')
        password = request.POST.get('password')
        
        try:
            user = User.objects.get(login=login, password=password)
            request.session['user_id'] = user.id_user
            request.session['user_name'] = user.full_name
            request.session['user_role'] = user.id_role.role_name
            return redirect('product_list')
        except User.DoesNotExist:
            return render(request, 'shop/login.html', {
                'error': 'Неверный логин или пароль'
            })
    
    return render(request, 'shop/login.html')


def guest_view(request):
    """Вход в систему в роли гостя"""
    request.session['user_name'] = 'Гость'
    request.session['user_role'] = 'Гость'
    request.session['user_id'] = None
    return redirect('product_list')


def logout_view(request):
    """Выход из системы"""
    request.session.flush()
    return redirect('login')


def product_list(request):
    """Список товаров с поиском, фильтрацией и сортировкой"""
    request.session.pop('editing_product', None)
    
    user_name = request.session.get('user_name', 'Гость')
    user_role = request.session.get('user_role', 'Гость')
    user_id = request.session.get('user_id')
    
    # Получаем все товары с связанными данными
    products = Product.objects.select_related(
        'id_category', 'id_manufacturer', 'id_supplier', 'id_unit'
    ).all()
    
    # Поиск (только для менеджера и администратора)
    if user_role in ['Менеджер', 'Администратор']:
        search_query = request.GET.get('search', '')
        if search_query:
            products = products.filter(
                Q(product_name__icontains=search_query) |
                Q(description__icontains=search_query) |
                Q(id_category__category_name__icontains=search_query) |
                Q(id_manufacturer__manufacturer_name__icontains=search_query) |
                Q(id_supplier__supplier_name__icontains=search_query)
            )
        
        # Фильтрация по производителю
        manufacturer_filter = request.GET.get('manufacturer', '')
        if manufacturer_filter:
            products = products.filter(id_manufacturer_id=manufacturer_filter)
        
        # Сортировка
        sort_by = request.GET.get('sort', 'product_name')
        sort_order = request.GET.get('order', 'asc')
        
        # Сохраняем параметры сортировки в сессии
        request.session['sort_by'] = sort_by
        request.session['sort_order'] = sort_order
        
        if sort_order == 'desc':
            sort_by = f'-{sort_by}'
        
        products = products.order_by(sort_by)
    
    # Получаем список производителей для фильтра
    manufacturers = Manufacturer.objects.all()
    
    context = {
        'products': products,
        'user_name': user_name,
        'user_role': user_role,
        'user_id': user_id,
        'manufacturers': manufacturers,
        'search_query': request.GET.get('search', ''),
        'manufacturer_filter': request.GET.get('manufacturer', ''),
        'sort_by': request.session.get('sort_by', 'product_name'),
        'sort_order': request.session.get('sort_order', 'asc'),
    }
    
    return render(request, 'shop/product_list.html', context)


def product_add(request):
    """Добавление нового товара (только администратор)"""
    user_role = request.session.get('user_role', 'Гость')
    
    # Проверка прав доступа
    if user_role != 'Администратор':
        messages.error(request, 'У вас нет прав для выполнения этого действия')
        return redirect('product_list')
    
    # Проверка: не открыто ли уже окно редактирования
    if request.session.get('editing_product'):
        messages.warning(
            request, 
            'У вас уже открыто окно редактирования товара. '
            'Завершите редактирование перед добавлением нового.'
        )
        return redirect('product_list')
    
    if request.method == 'POST':
        try:
            # Получаем данные из формы
            product_name = request.POST.get('product_name')
            id_category = request.POST.get('id_category')
            description = request.POST.get('description')
            id_manufacturer = request.POST.get('id_manufacturer')
            id_supplier = request.POST.get('id_supplier')
            price = request.POST.get('price')
            id_unit = request.POST.get('id_unit')
            stock_quantity = request.POST.get('stock_quantity')
            discount_percent_str = request.POST.get('discount_percent', '0').strip()
            discount_percent = int(discount_percent_str) if discount_percent_str else 0
            
            # Валидация данных
            if not product_name:
                messages.error(request, 'Наименование товара обязательно для заполнения')
                return render(request, 'shop/product_form.html', get_form_context(request))
            
            try:
                price = float(price)
                if price < 0:
                    messages.error(request, 'Цена не может быть отрицательной')
                    return render(request, 'shop/product_form.html', get_form_context(request))
            except (ValueError, TypeError):
                messages.error(request, 'Некорректное значение цены')
                return render(request, 'shop/product_form.html', get_form_context(request))
            
            try:
                stock_quantity = int(stock_quantity)
                if stock_quantity < 0:
                    messages.error(request, 'Количество на складе не может быть отрицательным')
                    return render(request, 'shop/product_form.html', get_form_context(request))
            except (ValueError, TypeError):
                messages.error(request, 'Некорректное значение количества')
                return render(request, 'shop/product_form.html', get_form_context(request))
            
            # Генерируем новый артикул
            last_product = Product.objects.order_by('-article').first()
            if last_product:
                new_article = f"NEW{int(last_product.article.replace('NEW', '')) + 1:03d}" if last_product.article.startswith('NEW') else f"NEW001"
            else:
                new_article = "NEW001"
            
            # Обработка загрузки фото
            photo_path = None
            photo_file = request.FILES.get('photo')
            if photo_file:
                # Сохраняем фото с ограничением размера 300x200
                img = Image.open(photo_file)
                img.thumbnail((300, 200), Image.Resampling.LANCZOS)
                
                # Создаём папку media если её нет
                media_dir = os.path.join(settings.MEDIA_ROOT)
                os.makedirs(media_dir, exist_ok=True)
                
                # Сохраняем фото
                photo_filename = f"{new_article}.jpg"
                photo_full_path = os.path.join(media_dir, photo_filename)
                img.save(photo_full_path, 'JPEG')
                photo_path = photo_filename
            
            # Создаём товар
            Product.objects.create(
                article=new_article,
                product_name=product_name,
                id_category_id=id_category,
                description=description,
                id_manufacturer_id=id_manufacturer,
                id_supplier_id=id_supplier,
                price=price,
                id_unit_id=id_unit,
                stock_quantity=stock_quantity,
                discount_percent=int(discount_percent) if discount_percent else 0,
                photo_path=photo_path
            )
            
            messages.success(request, f'Товар "{product_name}" успешно добавлен')
            return redirect('product_list')
            
        except Exception as e:
            messages.error(request, f'Ошибка при добавлении товара: {str(e)}')
    
    return render(request, 'shop/product_form.html', get_form_context(request))


def product_edit(request, article):
    """Редактирование товара (только администратор)"""
    user_role = request.session.get('user_role', 'Гость')
    
    # Проверка прав доступа
    if user_role != 'Администратор':
        messages.error(request, 'У вас нет прав для выполнения этого действия')
        return redirect('product_list')
    
    # Проверка: не открыто ли уже окно редактирования
    if request.session.get('editing_product') and request.session.get('editing_product') != article:
        messages.warning(
            request, 
            'У вас уже открыто окно редактирования другого товара. '
            'Завершите текущее редактирование.'
        )
        return redirect('product_list')
    
    # Помечаем, что открыто окно редактирования
    request.session['editing_product'] = article
    
    product = get_object_or_404(Product, article=article)
    
    if request.method == 'POST':
        try:
            # Получаем данные из формы
            product.product_name = request.POST.get('product_name')
            product.id_category_id = request.POST.get('id_category')
            product.description = request.POST.get('description')
            product.id_manufacturer_id = request.POST.get('id_manufacturer')
            product.id_supplier_id = request.POST.get('id_supplier')
            product.price = float(request.POST.get('price'))
            product.id_unit_id = request.POST.get('id_unit')
            product.stock_quantity = int(request.POST.get('stock_quantity'))
            discount_percent_str = request.POST.get('discount_percent', '0').strip()
            product.discount_percent = int(discount_percent_str) if discount_percent_str else 0
            
            # Валидация
            if product.price < 0:
                messages.error(request, 'Цена не может быть отрицательной')
                return render(request, 'shop/product_form.html', get_form_context(request, product))
            
            if product.stock_quantity < 0:
                messages.error(request, 'Количество на складе не может быть отрицательным')
                return render(request, 'shop/product_form.html', get_form_context(request, product))
            
            # Обработка загрузки нового фото
            photo_file = request.FILES.get('photo')
            if photo_file:
                # Удаляем старое фото если оно есть
                if product.photo_path:
                    old_photo_path = os.path.join(settings.MEDIA_ROOT, product.photo_path)
                    if os.path.exists(old_photo_path):
                        os.remove(old_photo_path)
                
                # Сохраняем новое фото с ограничением размера
                img = Image.open(photo_file)
                img.thumbnail((300, 200), Image.Resampling.LANCZOS)
                
                photo_filename = f"{product.article}.jpg"
                photo_full_path = os.path.join(settings.MEDIA_ROOT, photo_filename)
                img.save(photo_full_path, 'JPEG')
                product.photo_path = photo_filename
            
            product.save()
            
            # Снимаем флаг редактирования
            request.session.pop('editing_product', None)
            
            messages.success(request, f'Товар "{product.product_name}" успешно обновлён')
            return redirect('product_list')
            
        except Exception as e:
            messages.error(request, f'Ошибка при редактировании товара: {str(e)}')
    
    context = get_form_context(request, product)
    context['is_edit'] = True
    return render(request, 'shop/product_form.html', context)


def product_delete(request, article):
    """Удаление товара (только администратор)"""
    user_role = request.session.get('user_role', 'Гость')
    
    # Проверка прав доступа
    if user_role != 'Администратор':
        messages.error(request, 'У вас нет прав для выполнения этого действия')
        return redirect('product_list')
    
    product = get_object_or_404(Product, article=article)
    
    # Проверяем, есть ли товар в заказах
    if OrderItem.objects.filter(article=article).exists():
        messages.error(
            request, 
            f'Нельзя удалить товар "{product.product_name}", '
            f'так как он присутствует в заказе'
        )
        return redirect('product_list')
    
    if request.method == 'POST':
        try:
            # Удаляем фото файла если оно есть
            if product.photo_path:
                photo_path = os.path.join(settings.MEDIA_ROOT, product.photo_path)
                if os.path.exists(photo_path):
                    os.remove(photo_path)
            
            product_name = product.product_name
            product.delete()
            
            messages.success(request, f'Товар "{product_name}" успешно удалён')
            
        except Exception as e:
            messages.error(request, f'Ошибка при удалении товара: {str(e)}')
    
    return redirect('product_list')


def get_form_context(request, product=None):
    """Вспомогательная функция для получения контекста формы"""
    context = {
        'user_name': request.session.get('user_name', 'Гость'),
        'user_role': request.session.get('user_role', 'Гость'),
        'categories': Category.objects.all(),
        'manufacturers': Manufacturer.objects.all(),
        'suppliers': Supplier.objects.all(),
        'units': Unit.objects.all(),
        'product': product,
    }
    
    # Если есть товар, конвертируем Decimal в float для корректного отображения
    if product:
        context['price_value'] = float(product.price)
        context['stock_quantity_value'] = product.stock_quantity
        context['discount_percent_value'] = product.discount_percent
    
    return context