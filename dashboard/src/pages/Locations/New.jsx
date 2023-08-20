

import TextBox from '@/Components/FormsComponents/Inputs/TextBox'
import Layout from '@/layout/Layout'
import React, { useState } from 'react'
import { toast } from 'react-toastify';
import api from '@/api/api';
import { useRouter } from 'next/router';
import 'react-toastify/dist/ReactToastify.css';
export default function New() {
    const router = useRouter();
    const [formData, setFormData] = useState({
        name: "",
    });

    const handleSave = async () => {
        const authToken = localStorage.getItem('authToken');
        try {
            const savedData = await api.post('locations/location/', formData, authToken);
            toast.success('تم حفظ البيانات بنجاح');
            router.push('/Locations');
        } catch (error) {
            console.error('Error saving data:', error);
            toast.error('هذا الموقع تمت اضافتة سابقا استخدم موقع اخر');
        }
    };
    return (
        <Layout>

            <div className="flex mt-5 flex-col w-full items-center justify-between pb-4 bg-white dark:bg-white rounded-md text-black">
                <div className="flex items-center space-x-4 w-full p-4" dir='rtl'>
                    <form className="w-full ">
                        <TextBox
                            type='text'
                            id='name'
                            label='اسم الموقع'
                            name='name'
                            placeholder='ادخل اسم الموقع'
                            value={formData.name}
                            onChange={(e) =>
                                setFormData({ ...formData, name: e.target.value })
                            }
                            error={formData.name == "" ? "هذا الحقل إجباري" : false}
                        />
                        <button type="button" onClick={handleSave}>حفظ</button>
                    </form>
                </div>
            </div>
        </Layout>
    )
}

