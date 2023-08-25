import PrimaryBt from '@/Components/FormsComponents/Buttons/PrimaryBt';
import Card from '@/Components/Card';
import DropDownList from '@/Components/FormsComponents/Inputs/DropDownList'
import Search from '@/Components/FormsComponents/Inputs/Search';
import Table from '@/Components/Table'
import { BsHouseDoor, BsGraphUp, BsFillBarChartFill, BsChartSquare, BsArrowRight } from 'react-icons/bs';
import Layout from '@/layout/Layout';
import CustomTable from '@/Components/CustomTable';
import Link from 'next/link';
import React, { useEffect, useState } from 'react';
import { useRouter } from 'next/router';
import { toast } from 'react-toastify';
import api from '@/api/api';
import { tableSearch } from '@/api/filtersData';
export default function Index() {
    const router = useRouter();
    const [locations, setLocations] = useState([]);
    const [searchResults, setSearchResults] = useState([]);


    async function fetchLocations() {
        const authToken = localStorage.getItem('authToken');
        try {
            const LocationssData = await api.get('locations/location', authToken);
            setLocations(LocationssData);
        } catch (error) {
            console.error('Error fetching Locations:', error);
        }
    }


    useEffect(() => {
        // قم بإجراء طلب HTTP لجلب العقارات


        // استدعاء الدالة لجلب البيانات
        fetchLocations();
    }, []);


    const columns = [
        { key: 'id', label: 'الرقم' },
        {
            key: 'attributes', label: 'الموقع',
            render: (item) => (
                <div>{item.attributes.name}</div>
            ),
        },

    ];

    const data = [
        {
            number: 1,

            name: "عدن",




        }, {
            number: 2,

            name: "صنعاء",




        },

    ];

    const handleSearch = (searchTerm) => {
        const searchedField = 'name'; // تعيين الحقل الذي ترغب في البحث فيه
        const filteredResults = tableSearch(searchTerm, locations, searchedField);
        setSearchResults(filteredResults);
    };

    const handleEdit = (item) => {
        router.push(`/Locations/Edit/?id=${item.id}`);
        console.log(item);
    };

    const handleDelete = async (item) => {
        const authToken = localStorage.getItem('authToken');
        try {
            await api.deleteFunc(`locations/location/${item.id}`, authToken);

            // إزالة العنصر المحذوف من القائمة
            const updatedLocations = locations.filter((location) => location.id !== item.id);
            setLocations(updatedLocations);
            toast.success('تم حذف الموقع بنجاح');
        } catch (error) {
            if (error.response && error.response.data.data === "Cannot delete this location due to foreign key constraints") {
                console.log(error);
                toast.error('لا يمكن حذف هذا الموقع لأنه مستخدم من قبل عقارات. قم بحذف العقارات المرتبطة به أولاً.');
            } else {
                console.log(error);
                toast.error('خطأ أثناء حذف الموقع');
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
                    title="عدد المواقع"
                    value={locations.length}
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
                                <Link href="/Locations/New">

                                    <PrimaryBt type="add" name="إضافة موقع جديد" />

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
                    data={searchResults.length > 0 ? searchResults : locations}
                    onEdit={handleEdit}
                    onDelete={handleDelete} />
            </div>
        </Layout>
    )
}
