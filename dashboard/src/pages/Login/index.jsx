import Image from 'next/image'
import React, { useState } from 'react';
import axios from 'axios';
import myLogo from '@/images/applogo.png';
// import { fetchCsrfToken } from '@laravel/sanctum';
const API_URL = "http://127.0.0.1:8000/api/admin/";
import { useRouter } from 'next/router';
export default function Index() {
    const router = useRouter();
    // async function fetchCsrfToken() {
    //     try {
    //         const response = await axios.get('http://127.0.0.1:8000/sanctum/csrf-cookie/', {
    //             headers: {
    //                 'Accept': 'application/vnd.api+json',
    //                 'Content-Type': 'application/vnd.api+json',
    //             }
    //         });
    //         const csrfToken = response.data.csrf_token;
    //         return csrfToken;
    //     } catch (error) {
    //         console.error('حدث خطأ أثناء جلب رمز CSRF:', error);
    //         throw error;
    //     }
    // }


    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');

    const handleSubmit = async (e) => {
        e.preventDefault();
        const headers = {
            "Content-Type": `application/vnd.api+json`,
            "Accept": `application/vnd.api+json`,

        };
        let data = new FormData();
        data.append('email', email);
        data.append('password', password);


        try {
            const response = await axios({
                method: 'post',
                url: 'login',
                baseURL: API_URL,
                data: data,
                headers: headers,
            });

            // تخزين رمز المصادقة في حالة التطبيق أو Local Storage
            localStorage.setItem('authToken', response.data.data.token); // افترض أن response.data.token هو رمز المصادقة
            localStorage.setItem('UserName', response.data.data.admin.name);
            console.log(response);
            console.log('تم تسجيل الدخول بنجاح!');
            router.push('/');

        } catch (error) {
            console.error('حدث خطأ أثناء تسجيل الدخول:', error.response.data.message);
        }
    };

    return (
        <div className="flex flex-row items-center justify-center w-full h-screen md:flex-row md:h-screen">
            <div className="flex items-center p-10 justify-center w-full md:w-1/2">
                <Image src={myLogo} alt="Login Image" width={400} height={400} />
            </div>
            {/* <div className="flex flex-col items-center justify-center w-full md:w-1/4">
                <div className="w-full max-w-md space-y-8">
                    <div>
                        <h1 className="text-2xl text-black font-bold">Welcome Admin!</h1>
                        <p className="mt-2 text-gray-600">
                            Please sign in to your account.
                        </p>
                    </div>
                    <form className="mt-8 space-y-6">
                        <div>
                            <label htmlFor="email" className="block font-bold text-gray-700">
                                Email address
                            </label>
                            <input
                                id="email"
                                type="email"
                                placeholder="Enter your email"
                                className="w-full px-4 py-3 mt-1 border-gray-300 rounded-md focus:border-indigo-500 focus:ring focus:ring-indigo-200"
                                required
                            />
                        </div>
                        <div>
                            <label
                                htmlFor="password"
                                className="block font-bold text-gray-700"
                            >
                                Password
                            </label>
                            <input
                                id="password"
                                type="password"
                                placeholder="Enter your password"
                                className="w-full px-4 py-3 mt-1 border-gray-300 rounded-md focus:border-indigo-500 focus:ring focus:ring-indigo-200"
                                required
                            />
                        </div>
                        <div>
                            <button
                                type="submit"
                                className="w-full px-4 py-3 font-bold text-white bg-indigo-500 rounded-md hover:bg-indigo-600 focus:outline-none focus:shadow-outline-indigo focus:border-indigo-700"
                            >
                                Sign In
                            </button>
                        </div>
                    </form>
                </div>
            </div> */}
            <div className="flex flex-col items-center justify-center w-full md:w-1/4" dir="rtl">
                <div className="w-full max-w-md space-y-8">
                    <div>
                        <h1 className="text-2xl text-black font-bold">مرحبًا بك، مدير النظام!</h1>
                        <p className="mt-2 text-gray-600">
                            يرجى تسجيل الدخول إلى حسابك.
                        </p>
                    </div>
                    <form className="mt-8 space-y-6" onSubmit={handleSubmit}>
                        <div>
                            <label htmlFor="email" className="block font-bold text-gray-700">
                                البريد الإلكتروني
                            </label>
                            <input
                                dir='ltr'
                                type="email"
                                value={email}
                                onChange={(e) => setEmail(e.target.value)}
                                placeholder="أدخل عنوان بريدك الإلكتروني"
                                className="w-full px-4 py-3 mt-1 text-black border-gray-300 rounded-md focus:border-indigo-500 focus:ring focus:ring-indigo-200"
                                required
                            />
                        </div>
                        <div>
                            <label
                                htmlFor="password"
                                className="block font-bold text-gray-700"
                            >
                                كلمة المرور
                            </label>
                            <input
                                dir='ltr'
                                id="password"
                                type="password"
                                value={password}
                                onChange={(e) => setPassword(e.target.value)}
                                placeholder="أدخل كلمة المرور"
                                className="w-full px-4 py-3 mt-1 text-black border-gray-300 rounded-md focus:border-indigo-500 focus:ring focus:ring-indigo-200"
                                required
                            />
                        </div>
                        <div>
                            <button
                                type="submit"
                                className="w-full px-4 py-3 font-bold text-white bg-indigo-500 rounded-md hover:bg-indigo-600 focus:outline-none focus:shadow-outline-indigo focus:border-indigo-700"
                            >
                                تسجيل الدخول
                            </button>
                        </div>
                    </form>
                </div>
            </div>

        </div>
    );
}
