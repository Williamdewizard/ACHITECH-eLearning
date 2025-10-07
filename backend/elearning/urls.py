from rest_framework import routers
from .views import CourseViewSet, MaterialViewSet, AssignmentViewSet, SubmissionViewSet

router = routers.DefaultRouter()
router.register(r'courses', CourseViewSet)
router.register(r'materials', MaterialViewSet)
router.register(r'assignments', AssignmentViewSet)
router.register(r'submissions', SubmissionViewSet)

urlpatterns = router.urls