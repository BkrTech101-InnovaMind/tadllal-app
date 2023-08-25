import PrimaryBt from '@/Components/FormsComponents/Buttons/PrimaryBt';
import Card from '@/Components/Card';
import DropDownList from '@/Components/FormsComponents/Inputs/DropDownList'
import Search from '@/Components/FormsComponents/Inputs/Search';
import Table from '@/Components/Table'
import { BsHouseDoor, BsGraphUp, BsFillBarChartFill, BsChartSquare, BsArrowRight } from 'react-icons/bs';
import Layout from '@/layout/Layout';
import CustomTable from '@/Components/CustomTable';
import Image from 'next/image';
import Link from 'next/link';
import React, { useEffect, useState } from 'react';
import api from '@/api/api';
import { useRouter } from 'next/router';
import { toast } from 'react-toastify';
import { tableSearch } from '@/api/filtersData';
export default function Index() {
    const router = useRouter();
    const [types, setTypes] = useState([]);
    const [searchResults, setSearchResults] = useState([]);
    async function fetchTypes() {
        const authToken = localStorage.getItem('authToken');
        try {
            const typesData = await api.get('types/types', authToken);
            setTypes(typesData);
        } catch (error) {
            console.error('Error fetching Types:', error);
        }
    }



    useEffect(() => {

        fetchTypes();
    }, []);

    const columns = [
        { key: 'id', label: 'الرقم' },
        {
            key: 'attributes', label: 'الصورة',
            render: (item) => (

                <div>  <Image width={50} height={50} className="w-10 h-10 rounded-full ml-2" src={item.attributes.image.startsWith('storage') ? `http://127.0.0.1:8000/${item.attributes.image}` : item.attributes.image} alt="Jese image" /></div>
            ),
        },

        {
            key: 'attributes', label: 'الاسم',
            render: (item) => (
                <div>{item.attributes.name}</div>
            ),
        },

    ];


    const handleSearch = (searchTerm) => {
        const searchedField = 'name'; // تعيين الحقل الذي ترغب في البحث فيه
        const filteredResults = tableSearch(searchTerm, types, searchedField);
        setSearchResults(filteredResults);
    };

    const handleEdit = (item) => {
        router.push(`Types/Edit?id=${item.id}`);
    };

    const handleDelete = async (item) => {
        const authToken = localStorage.getItem('authToken');
        try {
            await api.deleteFunc(`types/types/${item.id}`, authToken);

            // إزالة العنصر المحذوف من القائمة
            const updatedTypes = types.filter((type) => type.id !== item.id);
            setTypes(updatedTypes);
            toast.success('تم حذف النوع بنجاح');
        } catch (error) {
            if (error.response && error.response.data.data === "Cannot delete this type due to foreign key constraints") {
                console.log(error);
                toast.error('لا يمكن حذف هذا النوع لأنه مستخدم من قبل عقارات. قم بحذف العقارات المرتبطة به أولاً.');
            } else {
                console.log(error);
                toast.error('خطأ أثناء حذف النوع');
            }
        }
    };
    return (

        <Layout>
            {/* // page container */}
            <div className="grid grid-cols-4 my-0 gap-4 md:grid-cols-1 py-0 text-black w-full" dir='rtl'>
                <Card
                    id="1"
                    icon={<BsHouseDoor size={69} color='#f584' />}
                    title="عدد أنواع العقارات"
                    value={types.length}
                    label="العدد الاجمالي"
                />

            </div>
            <div className="flex mt-5 flex-col w-full items-center justify-between pb-4 bg-white dark:bg-white rounded-md text-black">


                {/* filter container */}

                <div className="flex items-center space-x-4 w-full p-4" dir='rtl'>
                    <div className="flex flex-col gap-y-4 w-full">

                        <div className='flex justify-between border-t-2 pt-5'>
                            <div>
                                {/* <PrimaryBt type="add" name="إضافة عقار جديد" onClick={() => { }} /> */}
                                <Link href="/Types/New">

                                    <PrimaryBt type="add" name="إضافة نوع جديد" />

                                </Link>
                                <PrimaryBt type="export" name="تصدير" onClick={() => { }} />
                            </div>


                            <div>
                                <Search onSearch={handleSearch} />
                            </div>
                        </div>
                    </div>
                </div>
                {/* <Table /> */}

                <CustomTable
                    columns={columns}
                    data={searchResults.length > 0 ? searchResults : types}
                    onEdit={handleEdit}
                    onDelete={handleDelete} />
            </div>
        </Layout>
    )
}
