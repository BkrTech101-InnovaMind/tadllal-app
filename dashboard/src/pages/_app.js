import Nav from '@/Components/Navbar';
import Sidebar from '@/Components/Sidebar';
import '@/styles/globals.css'
import { useEffect, useState } from 'react';
import { useRouter } from 'next/router';
import axios from 'axios';
const API_URL = "http://127.0.0.1:8000/api/";
import { ToastContainer } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import { LoadingProvider } from '@/Context API/LoadingContext';
export default function App({ Component, pageProps }) {
  const [user, setUser] = useState(null);
  const router = useRouter();
  async function checkUserStatus() {
    const headers = {
      "Content-Type": `application/vnd.api+json`,
      "Accept": `application/vnd.api+json`,
      "Authorization": `Bearer ${localStorage.getItem('authToken')}`
    };
    try {
      const response = await axios.get('user', { // تم تعديل هنا

        baseURL: API_URL, // تم تعديل هنا
        headers: headers,
      });
      const userData = response.data;
      setUser(userData);
      console.log(userData);
      console.log(user);

    } catch (error) {
      // إذا كان هناك خطأ (مثل 401 Unauthorized)، قم بتفريغ حالة المستخدم
      setUser(null);
    }
    if (!localStorage.getItem('authToken') && !user && router.pathname !== '/Login') {
      router.push('/Login');
    }
    if (localStorage.getItem('authToken') && user && router.pathname === '/Login') {
      router.push('/');
    }
  }
  // تحقق من حالة المستخدم عند تحميل الصفحة
  // useEffect(() => {
  //   // قم بإستدعاء API للتحقق من حالة تسجيل الدخول
  //   checkUserStatus();


  // }, []);

  // تحقق من حالة المستخدم قبل تحميل الصفحة
  useEffect(() => {
    checkUserStatus();
    // إذا كان المستخدم غير مسجل دخول، قم بتوجيهه إلى صفحة تسجيل الدخول

  }, [router.pathname, router]);


  return (
    <LoadingProvider>
      <Component {...pageProps} />
      <ToastContainer />
    </LoadingProvider>);

}
