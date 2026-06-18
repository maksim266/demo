from django.db import models
from decimal import Decimal

class Role(models.Model):
    id_role = models.AutoField(primary_key=True)
    role_name = models.CharField(max_length=50, unique=True)

    class Meta:
        managed = False
        db_table = 'roles'

    def __str__(self):
        return self.role_name

class Category(models.Model):
    id_category = models.AutoField(primary_key=True)
    category_name = models.CharField(max_length=100, unique=True)

    class Meta:
        managed = False
        db_table = 'categories'

    def __str__(self):
        return self.category_name

class Manufacturer(models.Model):
    id_manufacturer = models.AutoField(primary_key=True)
    manufacturer_name = models.CharField(max_length=100, unique=True)

    class Meta:
        managed = False
        db_table = 'manufacturers'

    def __str__(self):
        return self.manufacturer_name

class Supplier(models.Model):
    id_supplier = models.AutoField(primary_key=True)
    supplier_name = models.CharField(max_length=100, unique=True)

    class Meta:
        managed = False
        db_table = 'suppliers'

    def __str__(self):
        return self.supplier_name

class Unit(models.Model):
    id_unit = models.AutoField(primary_key=True)
    unit_name = models.CharField(max_length=20, unique=True)

    class Meta:
        managed = False
        db_table = 'units'

    def __str__(self):
        return self.unit_name

class User(models.Model):
    id_user = models.AutoField(primary_key=True)
    full_name = models.CharField(max_length=150)
    login = models.CharField(max_length=100, unique=True)
    password = models.CharField(max_length=50)
    id_role = models.ForeignKey(Role, on_delete=models.RESTRICT, db_column='id_role')

    class Meta:
        managed = False
        db_table = 'users'

    def __str__(self):
        return self.full_name

class Product(models.Model):
    article = models.CharField(max_length=10, primary_key=True)
    product_name = models.CharField(max_length=150)
    id_category = models.ForeignKey(Category, on_delete=models.RESTRICT, db_column='id_category')
    id_manufacturer = models.ForeignKey(Manufacturer, on_delete=models.RESTRICT, db_column='id_manufacturer')
    id_supplier = models.ForeignKey(Supplier, on_delete=models.RESTRICT, db_column='id_supplier')
    id_unit = models.ForeignKey(Unit, on_delete=models.RESTRICT, db_column='id_unit')
    price = models.DecimalField(max_digits=10, decimal_places=2)
    discount_percent = models.IntegerField(default=0)
    stock_quantity = models.IntegerField(default=0)
    description = models.TextField(blank=True, null=True)
    photo_path = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'products'

    def __str__(self):
        return self.product_name

    def get_final_price(self):
        if self.discount_percent > 0:
            discount = Decimal(self.discount_percent) / Decimal(100)
            return self.price * (1 - discount)
        return self.price
    
class OrderItem(models.Model):
    """Состав заказа (позиция заказа)"""
    id_order = models.IntegerField()
    article = models.CharField(max_length=10)
    quantity = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'order_items'
        # Составной первичный ключ
        constraints = [
            models.UniqueConstraint(
                fields=['id_order', 'article'],
                name='order_items_pkey'
            )
        ]

    def __str__(self):
        return f"Заказ #{self.id_order} - {self.article}"