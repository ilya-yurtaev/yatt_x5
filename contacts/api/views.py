from rest_framework.generics import ListAPIView

from .serializers import (
    PhoneBookSerializer,
)

from ..models import Phone


class PhoneBookView(ListAPIView):
    serializer_class = PhoneBookSerializer

    def get_queryset(self):
        qs = Phone.objects.select_related(
            'contact',
        ).order_by('created_at')

        created_at = self.request.GET.get('created_at__gt')

        if created_at:
            try:
                qs = qs.filter(created_at__gt=created_at)
            except Exception:
                pass

        return qs
