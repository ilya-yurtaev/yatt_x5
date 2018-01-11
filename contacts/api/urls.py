from django.urls import path

from .views import PhoneBookView


urlpatterns = [
    path(r'phonebook/', PhoneBookView.as_view(), name='phonebook'),
]
