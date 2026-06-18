from django.urls import path
from . import views

urlpatterns = [
    path('', views.login_view, name='login'),
    path('guest/', views.guest_view, name='guest'),
    path('logout/', views.logout_view, name='logout'),
    path('products/', views.product_list, name='product_list'),
    path('products/add/', views.product_add, name='product_add'),
    path('products/<str:article>/edit/', views.product_edit, name='product_edit'),
    path('products/<str:article>/delete/', views.product_delete, name='product_delete'),
]