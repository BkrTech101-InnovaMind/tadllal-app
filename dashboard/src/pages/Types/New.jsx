import TextBox from '@/Components/FormsComponents/Inputs/TextBox'
import Layout from '@/layout/Layout'
import React, { useState } from 'react'
import api from '@/api/api';
import { useRouter } from 'next/router';
import { toast } from 'react-toastify';
export default function AddTypes() {
    const router = useRouter();
    const [formData, setFormData] = useState({
        name: "",
        image: null
    });

    const handleSave = async () => {
        const authToken = localStorage.getItem('authToken');
        try {
            const formDataForApi = new FormData(); // Create a FormData object
            formDataForApi.append('name', formData.name);
            formDataForApi.append('image', formData.image); // Append the image file to FormData

            const savedData = await api.post('types/types/', formDataForApi, authToken);
            toast.success('تم حفظ البيانات بنجاح');
            router.push('/Types');
        } catch (error) {
            console.error('Error saving data:', error);
            toast.error('هذا النوع تمت اضافتة سابقا استخدم نوع اخر');
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
                            label='اسم النوع'
                            name='name'
                            placeholder='ادخل اسم النوع'
                            value={formData.name}
                            onChange={(e) =>
                                setFormData({ ...formData, name: e.target.value })
                            }
                            error={formData.name == "" ? "هذا الحقل إجباري" : false}
                        />

                        <TextBox
                            type='file'
                            id='image'
                            label='  صورة النوع'
                            name='image'
                            placeholder='ادخل صورة النوع'
                            value={formData.price}
                            onChange={(e) =>
                                setFormData({ ...formData, image: e.target.files[0] })
                            }
                            error={formData.image == "" ? "هذا الحقل إجباري" : false}
                        />
                        <button type="button" onClick={handleSave}>حفظ</button>
                    </form>
                </div>
            </div>
        </Layout>
    )
}
