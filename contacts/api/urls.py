from django.urls import path
from rest_framework.routers import DefaultRouter

from .views import ContactViewset, PhoneViewset, PhoneBookView


router = DefaultRouter()
router.register(r'contacts', ContactViewset, base_name='contact')
router.register(r'phones', PhoneViewset, base_name='phone')


urlpatterns = [
    path(r'phonebook/', PhoneBookView.as_view(), name='phonebook'),
]
