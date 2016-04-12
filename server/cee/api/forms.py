# -*- coding: utf-8 -*-

from django.contrib.auth.models import User
from django.contrib.auth.forms import UserCreationForm
from django.forms import ModelForm, EmailField


class UserForm(ModelForm):
    email = EmailField(required=True)

    class Meta:
        model = User
        fields = ('username', 'email', 'password')
