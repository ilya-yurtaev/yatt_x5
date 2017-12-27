from rest_framework import viewsets
from rest_framework.generics import ListAPIView

from .serializers import (
    ContactSerializer,
    PhoneSerializer,
    PhoneBookSerializer,
)

from ..models import Contact, Phone


class ContactViewset(viewsets.ModelViewSet):
    serializer_class = ContactSerializer
    queryset = Contact.objects.all()


class PhoneViewset(viewsets.ModelViewSet):
    serializer_class = PhoneSerializer
    queryset = Phone.objects.select_related('contact')


class PhoneBookView(ListAPIView):
    serializer_class = PhoneBookSerializer
    queryset = Phone.objects.select_related(
        'contact',
    ).order_by('contact_id')
    filter_fields = ['created_at', 'value']
