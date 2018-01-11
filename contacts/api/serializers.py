from rest_framework import serializers
from drf_writable_nested import WritableNestedModelSerializer

from ..models import Contact, Phone


class ContactSerializer(serializers.ModelSerializer):
    class Meta:
        exclude = []
        model = Contact
        read_only_fields = ['id']


class PhoneSerializer(WritableNestedModelSerializer):
    class Meta:
        exclude = []
        model = Phone
        read_only_fields = ['id']


class PhoneBookSerializer(serializers.ModelSerializer):
    full_name = serializers.CharField(source='contact.full_name')
    address = serializers.CharField(source='contact.address')
    phone = serializers.SerializerMethodField()

    def get_phone(self, obj):
        return obj.pretty_print

    class Meta:
        fields = [
            'contact_id', 'full_name', 'address', 'phone',
            'created_at',
        ]
        model = Phone
