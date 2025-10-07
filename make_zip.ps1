# PowerShell script to generate MUBS-eLearning project and zip it on Windows
# Run in a writable folder: .\make_zip.ps1

$ErrorActionPreference = "Stop"

$Root = Get-Location
$AppRoot = Join-Path $Root "MUBS-eLearning"

# Create directories
New-Item -ItemType Directory -Force -Path `
  "$AppRoot\backend\elearning\migrations", `
  "$AppRoot\frontend\public", `
  "$AppRoot\frontend\src\pages", `
  "$AppRoot\frontend\src\components", `
  "$AppRoot\docs" | Out-Null

# -------------------------
# Backend files (Django)
# -------------------------

# manage.py
@'
#!/usr/bin/env python
import os
import sys

def main():
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'elearning.settings')
    try:
        from django.core.management import execute_from_command_line
    except ImportError as exc:
        raise ImportError("Couldn't import Django. Are you sure it's installed?") from exc
    execute_from_command_line(sys.argv)

if __name__ == '__main__':
    main()
'@ | Set-Content -Path "$AppRoot\backend\manage.py" -Encoding UTF8

# elearning package files (empty)
New-Item -ItemType File -Force -Path "$AppRoot\backend\elearning\__init__.py" | Out-Null
New-Item -ItemType File -Force -Path "$AppRoot\backend\elearning\migrations\__init__.py" | Out-Null

# elearning/settings.py
@'
import os
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent

SECRET_KEY = 'replace-this-with-a-secret-key'
DEBUG = True
ALLOWED_HOSTS = ['*']

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'rest_framework',
    'elearning',  # using project package as an app for simplicity
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common(CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'elearning.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [BASE_DIR / 'templates'],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'elearning.wsgi.application'
ASGI_APPLICATION = 'elearning.asgi.application'

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': str(BASE_DIR / 'db.sqlite3'),
    }
}

AUTH_PASSWORD_VALIDATORS = []

LANGUAGE_CODE = 'en-us'
TIME_ZONE = 'Africa/Kampala'
USE_I18N = True
USE_TZ = True

STATIC_URL = '/static/'
STATIC_ROOT = str(BASE_DIR / 'staticfiles')
MEDIA_URL = '/media/'
MEDIA_ROOT = str(BASE_DIR / 'media')

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework.authentication.SessionAuthentication',
        'rest_framework.authentication.BasicAuthentication',
    ),
}

# Use custom user model defined below
AUTH_USER_MODEL = 'elearning.User'
'@ | Set-Content -Path "$AppRoot\backend\elearning\settings.py" -Encoding UTF8

# elearning/urls.py
@'
from django.contrib import admin
from django.urls import path, include
from rest_framework import routers
from django.conf import settings
from django.conf.urls.static import static
from elearning import views

router = routers.DefaultRouter()
router.register(r'users', views.UserViewSet)
router.register(r'courses', views.CourseViewSet)
router.register(r'materials', views.MaterialViewSet)
router.register(r'assignments', views.AssignmentViewSet)
router.register(r'submissions', views.SubmissionViewSet)

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include(router.urls)),
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
'@ | Set-Content -Path "$AppRoot\backend\elearning\urls.py" -Encoding UTF8

# elearning/wsgi.py
@'
import os
from django.core.wsgi import get_wsgi_application
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'elearning.settings')
application = get_wsgi_application()
'@ | Set-Content -Path "$AppRoot\backend\elearning\wsgi.py" -Encoding UTF8

# elearning/asgi.py
@'
import os
from django.core.asgi import get_asgi_application
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'elearning.settings')
application = get_asgi_application()
'@ | Set-Content -Path "$AppRoot\backend\elearning\asgi.py" -Encoding UTF8

# elearning/models.py
@'
from django.contrib.auth.models import AbstractUser
from django.db import models

class User(AbstractUser):
    is_student = models.BooleanField(default=False)
    is_lecturer = models.BooleanField(default=False)
    is_admin = models.BooleanField(default=False)

class Course(models.Model):
    title = models.CharField(max_length=255)
    description = models.TextField()
    instructor = models.ForeignKey(User, on_delete=models.CASCADE)
    version = models.IntegerField(default=1)

    def __str__(self):
        return self.title

class Material(models.Model):
    course = models.ForeignKey(Course, on_delete=models.CASCADE, related_name='materials')
    content_file = models.FileField(upload_to='materials/')
    uploaded_at = models.DateTimeField(auto_now_add=True)
    version = models.IntegerField(default=1)

class Assignment(models.Model):
    course = models.ForeignKey(Course, on_delete=models.CASCADE, related_name='assignments')
    title = models.CharField(max_length=255)
    description = models.TextField()
    due_date = models.DateField()
    created_at = models.DateTimeField(auto_now_add=True)

class Submission(models.Model):
    assignment = models.ForeignKey(Assignment, on_delete=models.CASCADE, related_name='submissions')
    student = models.ForeignKey(User, on_delete=models.CASCADE, related_name='submissions')
    file = models.FileField(upload_to='submissions/')
    submitted_at = models.DateTimeField(auto_now_add=True)
    feedback = models.TextField(null=True, blank=True)
    graded = models.BooleanField(default=False)
'@ | Set-Content -Path "$AppRoot\backend\elearning\models.py" -Encoding UTF8

# elearning/serializers.py
@'
from rest_framework import serializers
from .models import User, Course, Material, Assignment, Submission

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id','username','first_name','last_name','email','is_student','is_lecturer','is_admin']

class MaterialSerializer(serializers.ModelSerializer):
    class Meta:
        model = Material
        fields = '__all__'

class AssignmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Assignment
        fields = '__all__'

class CourseSerializer(serializers.ModelSerializer):
    materials = MaterialSerializer(many=True, read_only=True)
    assignments = AssignmentSerializer(many=True, read_only=True)

    class Meta:
        model = Course
        fields = ['id','title','description','instructor','version','materials','assignments']

class SubmissionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Submission
        fields = '__all__'
'@ | Set-Content -Path "$AppRoot\backend\elearning\serializers.py" -Encoding UTF8

# elearning/views.py
@'
from rest_framework import viewsets
from .models import User, Course, Material, Assignment, Submission
from .serializers import UserSerializer, CourseSerializer, MaterialSerializer, AssignmentSerializer, SubmissionSerializer

class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all().order_by('id')
    serializer_class = UserSerializer

class CourseViewSet(viewsets.ModelViewSet):
    queryset = Course.objects.all().order_by('id')
    serializer_class = CourseSerializer

class MaterialViewSet(viewsets.ModelViewSet):
    queryset = Material.objects.all().order_by('-uploaded_at')
    serializer_class = MaterialSerializer

class AssignmentViewSet(viewsets.ModelViewSet):
    queryset = Assignment.objects.all().order_by('-created_at')
    serializer_class = AssignmentSerializer

class SubmissionViewSet(viewsets.ModelViewSet):
    queryset = Submission.objects.all().order_by('-submitted_at')
    serializer_class = SubmissionSerializer
'@ | Set-Content -Path "$AppRoot\backend\elearning\views.py" -Encoding UTF8

# elearning/admin.py
@'
from django.contrib import admin
from .models import User, Course, Material, Assignment, Submission

@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    list_display = ('username','email','is_student','is_lecturer','is_admin')

@admin.register(Course)
class CourseAdmin(admin.ModelAdmin):
    list_display = ('title','instructor','version')

@admin.register(Material)
class MaterialAdmin(admin.ModelAdmin):
    list_display = ('course','uploaded_at','version')

@admin.register(Assignment)
class AssignmentAdmin(admin.ModelAdmin):
    list_display = ('title','course','due_date','created_at')

@admin.register(Submission)
class SubmissionAdmin(admin.ModelAdmin):
    list_display = ('assignment','student','submitted_at','graded')
'@ | Set-Content -Path "$AppRoot\backend\elearning\admin.py" -Encoding UTF8

# .gitignore (root)
@'
# Python
__pycache__/
*.pyc
*.pyo
*.pyd
env/
venv/
.venv/
db.sqlite3

# Django
staticfiles/
media/

# Node
node_modules/
dist/
build/

# OS
.DS_Store
Thumbs.db
'@ | Set-Content -Path "$AppRoot\.gitignore" -Encoding UTF8

# -------------------------
# Frontend files (React)
# -------------------------

# package.json
@'
{
  "name": "mubs-elearning-frontend",
  "version": "1.0.0",
  "private": true,
  "dependencies": {
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "react-router-dom": "^6.26.2",
    "react-scripts": "^5.0.1"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test --env=jsdom",
    "eject": "react-scripts eject"
  },
  "browserslist": {
    "production": [">0.2%", "not dead", "not op_mini all"],
    "development": ["last 1 chrome version", "last 1 firefox version", "last 1 safari version"]
  }
}
'@ | Set-Content -Path "$AppRoot\frontend\package.json" -Encoding UTF8

# public/index.html
@'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <link rel="manifest" href="manifest.json" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <meta name="theme-color" content="#1976d2" />
  <title>MUBS E-Learning</title>
</head>
<body>
  <noscript>You need to enable JavaScript to run this app.</noscript>
  <div id="root"></div>
</body>
</html>
'@ | Set-Content -Path "$AppRoot\frontend\public\index.html" -Encoding UTF8

# public/manifest.json
@'
{
  "short_name": "MUBS E-Learning",
  "name": "Makerere University Business School E-Learning",
  "icons": [],
  "start_url": ".",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#1976d2"
}
'@ | Set-Content -Path "$AppRoot\frontend\public\manifest.json" -Encoding UTF8

# src/index.js
@'
import React from "react";
import { createRoot } from "react-dom/client";
import App from "./App";

const root = createRoot(document.getElementById("root"));
root.render(<App />);
'@ | Set-Content -Path "$AppRoot\frontend\src\index.js" -Encoding UTF8

# src/App.js
@'
import React from "react";
import { BrowserRouter, Route, Routes, Link } from "react-router-dom";
import Home from "./pages/Home";
import Courses from "./pages/Courses";
import Assignment from "./pages/Assignment";
import Login from "./pages/Login";
import OfflineBanner from "./components/OfflineBanner";

function App() {
  return (
    <BrowserRouter>
      <OfflineBanner />
      <nav style={{ padding: 12, background: "#f5f5f5" }}>
        <Link to="/" style={{ marginRight: 12 }}>Home</Link>
        <Link to="/courses" style={{ marginRight: 12 }}>Courses</Link>
        <Link to="/login">Login</Link>
      </nav>
      <div style={{ padding: 16 }}>
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/courses" element={<Courses />} />
          <Route path="/assignment/:id" element={<Assignment />} />
          <Route path="/login" element={<Login />} />
        </Routes>
      </div>
    </BrowserRouter>
  );
}

export default App;
'@ | Set-Content -Path "$AppRoot\frontend\src\App.js" -Encoding UTF8

# src/pages/Home.js
@'
import React from "react";
export default function Home() {
  return (
    <div>
      <h2>Welcome to MUBS E-Learning!</h2>
      <p>Login or browse your courses.</p>
    </div>
  );
}
'@ | Set-Content -Path "$AppRoot\frontend\src\pages\Home.js" -Encoding UTF8

# src/pages/Courses.js
@'
import React from "react";
export default function Courses() {
  return (
    <div>
      <h2>Your Courses</h2>
      <p>List of courses will appear here.</p>
    </div>
  );
}
'@ | Set-Content -Path "$AppRoot\frontend\src\pages\Courses.js" -Encoding UTF8

# src/pages/Assignment.js
@'
import React from "react";
export default function Assignment() {
  return (
    <div>
      <h2>Assignment Details</h2>
      <p>Assignment content and submission form here.</p>
    </div>
  );
}
'@ | Set-Content -Path "$AppRoot\frontend\src\pages\Assignment.js" -Encoding UTF8

# src/pages/Login.js
@'
import React from "react";
export default function Login() {
  return (
    <div>
      <h2>Login</h2>
      <form onSubmit={(e) => e.preventDefault()}>
        <input type="text" placeholder="Username" /><br />
        <input type="password" placeholder="Password" /><br />
        <button type="submit">Login</button>
      </form>
    </div>
  );
}
'@ | Set-Content -Path "$AppRoot\frontend\src\pages\Login.js" -Encoding UTF8

# src/components/OfflineBanner.js
@'
import React, { useEffect, useState } from "react";

const OfflineBanner = () => {
  const [isOffline, setIsOffline] = useState(!navigator.onLine);

  useEffect(() => {
    const goOnline = () => setIsOffline(false);
    const goOffline = () => setIsOffline(true);
    window.addEventListener("online", goOnline);
    window.addEventListener("offline", goOffline);
    return () => {
      window.removeEventListener("online", goOnline);
      window.removeEventListener("offline", goOffline);
    };
  }, []);

  return isOffline ? (
    <div style={{ background: "orange", color: "white", padding: "8px", textAlign: "center" }}>
      You are offline. Changes will sync when internet is available.
    </div>
  ) : null;
};

export default OfflineBanner;
'@ | Set-Content -Path "$AppRoot\frontend\src\components\OfflineBanner.js" -Encoding UTF8

# -------------------------
# Docs
# -------------------------
@'
# MUBS E-Learning System

An offline-first e-learning starter with:
- Backend: Django REST Framework (SQLite)
- Frontend: React (Create React App)

## Run locally

### Backend