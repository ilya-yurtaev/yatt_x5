# Generated by Django 2.0 on 2017-12-27 03:16

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('contacts', '0002_auto_20171227_0223'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='contact',
            name='modified_at',
        ),
        migrations.RemoveField(
            model_name='phone',
            name='modified_at',
        ),
    ]
