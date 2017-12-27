from django.db import models

from common.models import UUIDMixin, TimestampMixin


class Contact(UUIDMixin, TimestampMixin):
    full_name = models.CharField(max_length=255)
    address = models.TextField()

    def __str__(self):
        return self.full_name


class Phone(UUIDMixin, TimestampMixin):
    contact = models.ForeignKey(Contact, on_delete=models.CASCADE)
    value = models.CharField(max_length=11)

    def __str__(self):
        return self.pretty_print

    @property
    def pretty_print(self):
        return "+{0} ({1}{2}{3}) {4}{5}{6}-{7}{8}-{9}{10}".format(*self.value)

    class Meta:
        ordering = ('-created_at', )
