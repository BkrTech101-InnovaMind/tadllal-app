import React, { useEffect } from 'react';
import axios from 'axios';
import { useRouter } from 'next/router';
const API_URL = "http://127.0.0.1:8000/api/dashboard/";
const LogoutPage = () => {
    const router = useRouter();
    const logout = async () => {
        try {
            const headers = {
                "Content-Type": `application/vnd.api+json`,
                "Accept": `application/vnd.api+json`,
                "Authorization": `Bearer ${localStorage.getItem('authToken')}`
            };
            const response = await axios({
                method: 'post',
                url: 'logout',
                baseURL: API_URL,
                headers: headers,
            });

            // مسح رمز المصادقة من Local Storage
            localStorage.removeItem('authToken');
            localStorage.removeItem('UserName');
            console.log('تم تسجيل الخروج بنجاح!');
            router.push('/Login');
        } catch (error) {
            console.error('حدث خطأ أثناء تسجيل الخروج:', error);
        }
    };
    useEffect(() => {


        logout();
    }, []);

    return <div>جارٍ تسجيل الخروج...</div>;
};

export default LogoutPage;