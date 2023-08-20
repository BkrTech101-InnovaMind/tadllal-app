import PrimaryBt from '@/Components/FormsComponents/Buttons/PrimaryBt';
import Card from '@/Components/Card';
import DropDownList from '@/Components/FormsComponents/Inputs/DropDownList'
import Search from '@/Components/FormsComponents/Inputs/Search';
import Table from '@/Components/Table'
import React, { useEffect, useState } from 'react';
import { BsHouseDoor, BsGraphUp, BsFillBarChartFill, BsChartSquare, BsArrowRight } from 'react-icons/bs';
import Layout from '@/layout/Layout';
import CustomTable from '@/Components/CustomTable';
import Image from 'next/image';
import Link from 'next/link';
import api from '@/api/api';
import { useRouter } from 'next/router';
export default function Index() {
    const router = useRouter();
    const [services, setServices] = useState([]);
    // const [showType, setShowType] = useState(1);
    const [endpoint, setEndpoint] = useState('services/services/');
    async function fetchTypes() {
        const authToken = localStorage.getItem('authToken');

        try {
            const servicesData = await api.get(endpoint, authToken);
            setServices(servicesData);

        } catch (error) {
            console.error('Error fetching Types:', error);
        }
    }

    useEffect(() => {

        fetchTypes();
    }, [endpoint]);

    const handleOptionSelect = (selectedId) => {
        if (selectedId == 1) {
            setEndpoint('services/services/');
        } else if (selectedId == 2) {
            setEndpoint('subServices/services/');
        }
        // fetchTypes();
        console.log(`Selected ID: ${selectedId}`);
    };
    const array = {
        "data": [
            {
                "id": "1",
                "attributes": {
                    "name": "الخدمات الرئيسية",
                }
            },
            {
                "id": "2",
                "attributes": {
                    "name": "الخدمات الفرعية",
                }
            },

        ]
    };

    const columns1 = [
        { key: 'id', label: 'الرقم' },
        {
            key: 'property',
            label: 'الخدمة',
            render: (item) => (
                <div className="flex items-center">

                    <Image width={50} height={50} className="w-10 h-10 rounded-full ml-2" src={item.attributes.image.startsWith('storage') ? `http://127.0.0.1:8000/${item.attributes.image}` : item.attributes.image} alt="Jese image" />
                    <div className="pl-3">
                        <div className="text-base font-semibold">{item.attributes.name}</div>

                    </div>
                </div>
            ),
        },
        {
            key: 'attributes', label: 'وصف الخدمة',
            render: (item) => (
                <div>{item.attributes.description}</div>
            ),
        },
        { key: 'sub_services_count', label: 'عدد الخدمات الفرعية' },

    ];
    const columns2 = [
        { key: 'id', label: 'الرقم' },
        {
            key: 'property',
            label: 'الخدمة',
            render: (item) => (
                <div className="flex items-center">

                    <Image width={50} height={50} className="w-10 h-10 rounded-full ml-2" src={item.attributes.image.startsWith('storage') ? `http://127.0.0.1:8000/${item.attributes.image}` : item.attributes.image} alt="Jese image" />
                    <div className="pl-3">
                        <div className="text-base font-semibold">{item.attributes.name}</div>

                    </div>
                </div>
            ),
        },
        {
            key: 'attributes', label: 'وصف الخدمة',
            render: (item) => (
                <div>{item.attributes.description}</div>
            ),
        }, {
            key: 'construction', label: 'الخدمة الرئيسية', // إضافة الحقل "وصف الخدمة"
            render: (item) => (
                // عرض الوصف إذا كان متوفرًا، وإلا عرض رسالة بدلاً منه
                item.attributes.construction ? <div>{item.attributes.construction}</div> : null
            ),
        },


    ];



    const data = [
        {
            number: 1,

            name: "خدمه انشائية",
            property: {
                imageSrc: "https://via.placeholder.com/640x480.png/00ee11?text=ullam",
            },
            count: 1,


        }, {
            number: 2,

            name: "خدمة توريد",
            property: {
                imageSrc: "https://via.placeholder.com/640x480.png/00ee11?text=ullam",
            },
            count: 6,



        },

    ];
    const handleSearch = (searchTerm) => {
        // يمكنك هنا تنفيذ البحث باستخدام searchTerm
        console.log('تم البحث عن:', searchTerm);
    };

    const handleEdit = (item) => {
        if (endpoint == 'services/services/') {
            router.push(`Services/Edit?id=${item.id}`);

        } else {
            router.push(`Services/Sub/Edit?id=${item.id}`);
        }
    };

    const handleDelete = (item) => {
        console.log(item);
    };
    return (

        <Layout>
            {/* // page container */}
            <div className="grid grid-cols-4 my-0 gap-4 md:grid-cols-1 py-0 text-black w-full" dir='rtl'>
                <Card
                    id="1"
                    icon={<BsHouseDoor size={69} color='#f584' />}
                    title="عدد الخدمات الرئيسية"
                    value="30"
                    label="العدد الاجمالي"
                />

                <Card
                    id="1"
                    icon={<BsHouseDoor size={69} color='#f584' />}
                    title="عدد الخدمات الفرعية"
                    value="30"
                    label="العدد الاجمالي"
                />

                <Card
                    id="1"
                    icon={<BsHouseDoor size={69} color='#f584' />}
                    title="عدد كل الخدمات"
                    value="30"
                    label="العدد الاجمالي"
                />
            </div>
            <div className="flex mt-5 flex-col w-full items-center justify-between pb-4 bg-white dark:bg-white rounded-md text-black">


                {/* filter container */}

                <div className="flex items-center space-x-4 w-full p-4" dir='rtl'>
                    <div className="flex flex-col gap-y-4 w-full">
                        <div>
                            <p>خيارات العرض</p>
                        </div>
                        <div className='flex w-full '>
                            <DropDownList title="عرض الخدمات" options={array.data} onSelect={handleOptionSelect} />

                            {/* <DropDownList />
                            <DropDownList />
                            <DropDownList /> */}
                        </div>
                        <div className='flex justify-between border-t-2 pt-5'>
                            <div>
                                {/* <PrimaryBt type="add" name="إضافة عقار جديد" onClick={() => { }} /> */}
                                <Link href="/Services/New">

                                    <PrimaryBt type="add" name="إضافة خدمة رئيسية جديدة" />

                                </Link>
                                <Link href="/Services/Sub/New">
                                    <PrimaryBt type="add" name="إضافة خدمة فرعية جديدة" />
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
                {endpoint == 'services/services/' ? <CustomTable
                    columns={columns1}
                    data={services}
                    onEdit={handleEdit}
                    onDelete={handleDelete} />

                    : <CustomTable
                        columns={columns2}
                        data={services}
                        onEdit={handleEdit}
                        onDelete={handleDelete} />

                }

            </div>
        </Layout>
    )
}
