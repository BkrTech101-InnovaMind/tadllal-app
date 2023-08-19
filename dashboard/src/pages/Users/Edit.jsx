import React, { useState, useEffect } from 'react';
import api from '@/api/api';
import { toast } from 'react-toastify';
import { useRouter } from 'next/router';
import DropDownList from '@/Components/FormsComponents/Inputs/DropDownList';
import TextBox from '@/Components/FormsComponents/Inputs/TextBox';
import Layout from '@/layout/Layout';
import PrimaryBt from '@/Components/FormsComponents/Buttons/PrimaryBt';
import Image from 'next/image';

export default function EditUser() {
    const router = useRouter();
    const { id } = router.query;

    const [formData, setFormData] = useState({
        name: '',
        email: '',
        password: '',
        password_confirmation: '',
        role: '',
    });

    const [oldFormData, setOldFormData] = useState({
        name: '',
        email: '',
        role: '',
    });

    useEffect(() => {
        const authToken = localStorage.getItem('authToken');
        const fetchUserData = async () => {
            try {
                const userData = await api.get(`users/users/${id}`, authToken);
                setFormData({
                    name: userData.attributes.name,
                    email: userData.attributes.email,
                    role: userData.attributes.role,
                });
                setOldFormData({
                    name: userData.attributes.name,
                    email: userData.attributes.email,
                    role: userData.attributes.role,
                });
            } catch (error) {
                console.error('Error fetching user data:', error);
                toast.error('فشل جلب البيانات');
            }
        };

        if (id) {
            fetchUserData();
        }
    }, [id]);





    const handleUpdate = async () => {
        const authToken = localStorage.getItem('authToken');
        try {
            const formDataForApi = new FormData();
            if (formData.name !== oldFormData.name) {
                formDataForApi.append('name', formData.name);
            }
            if (formData.email !== oldFormData.email) {
                formDataForApi.append('email', formData.email);
            }
            if (formData.role !== oldFormData.role) {
                formDataForApi.append('role', formData.role);
            }
            if ((formData.password && formData.password_confirmation) && (formData.password == formData.password_confirmation)) {
                formDataForApi.append('password', formData.password);
                formDataForApi.append('password_confirmation', formData.password_confirmation);
            }

            if (formData.name == oldFormData.name && formData.email == oldFormData.email && formData.role == oldFormData.role && formData.password === '' &&
                formData.password_confirmation === '') {
                toast.warning('لم تقم بتعديل اي شيء');
                router.push('/Users');
            } else {
                const response = await api.post(`users/edit/${id}`, formDataForApi, authToken);
                toast.success('تم تحديث البيانات بنجاح');
                router.push('/Users');
            }


        } catch (error) {
            console.error('Error updating user data:', error);
            toast.error('حدث خطأ أثناء تحديث البيانات.');
        }
    };

    const array = {
        data: [
            { id: 'user', attributes: { name: 'مستخدم' } },
            { id: 'admin', attributes: { name: 'مشرف' } },
            { id: 'marketer', attributes: { name: 'مسوق' } },
            { id: 'company', attributes: { name: 'شركة' } },
        ],
    };

    return (
        <Layout>
            <div className="flex mt-5 flex-col w-full items-center justify-between pb-4 bg-white dark:bg-white rounded-md text-black">
                <div className="flex items-center space-x-4 w-full p-4" dir="rtl">
                    <form className="w-full">
                        <DropDownList
                            title="نوع المستخدم"
                            options={array.data}
                            selectedValue={formData.role}
                            onSelect={(e) => setFormData({ ...formData, role: e })}
                        />
                        <TextBox
                            type="text"
                            id="name"
                            label="اسم المستخدم"
                            name="name"
                            placeholder="ادخل اسم المستخدم"
                            value={formData.name}
                            onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                            error={formData.name === '' ? 'هذا الحقل إجباري' : false}
                        />
                        <TextBox
                            type="email"
                            id="email"
                            label="البريد الالكتروني"
                            name="email"
                            placeholder="ادخل البريد الالكتروني"
                            value={formData.email}
                            onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                            error={formData.email === '' ? 'هذا الحقل إجباري' : false}
                        />
                        <TextBox
                            type="password"
                            id="password"
                            label="كلمة المرور"
                            name="password"
                            placeholder="ادخل كلمة المرور"
                            value=''
                            onChange={(e) => setFormData({ ...formData, password: e.target.value })}
                            error={formData.password === '' ? 'هذا الحقل إجباري' : false}
                        />
                        <TextBox
                            type="password"
                            id="password_confirmation"
                            label="تأكيد كلمة المرور"
                            name="password_confirmation"
                            placeholder="أعد إدخال كلمة المرور"

                            onChange={(e) => setFormData({ ...formData, password_confirmation: e.target.value })}
                            error={formData.password_confirmation === '' ? 'هذا الحقل إجباري' : false}
                        />
                        <PrimaryBt
                            type="button"
                            name="تحديث"
                            onClick={handleUpdate}

                        />
                    </form>
                </div>
            </div>
        </Layout>
    );
}
