export async function getCourses() {
  const res = await fetch("/api/courses/");
  if (!res.ok) throw new Error(`Failed to fetch courses: ${res.status}`);
  return res.json();
}