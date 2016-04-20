from django.utils.decorators import method_decorator
from django.views.generic import ListView
from django.contrib.admin.views.decorators import staff_member_required

from api.models import Coupon


@method_decorator(staff_member_required, name='dispatch')
class CouponList(ListView):
    model = Coupon
    template_name = 'cms/coupons.html'
    context_object_name = 'coupons'
    paginate_by = 20

