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
import axios from 'axios';
import { useRouter } from 'next/router';
const API_URL = "http://127.0.0.1:8000/api/dashboard/locations/";
export default function Index() {
    const router = useRouter();
    const handleOptionSelect = (selectedId) => {
        console.log(`Selected ID: ${selectedId}`);
    };
    const [locations, setLocations] = useState([]);
    async function fetchLocations() {

        try {
            const response = await axios.get('location', {
                baseURL: API_URL,
                headers: {
                    "Content-Type": `application/vnd.api+json`,
                    "Accept": `application/vnd.api+json`,
                    "Authorization": `Bearer ${localStorage.getItem('authToken')}`,
                },
            });

            const LocationssData = response.data.data;
            setLocations(LocationssData);
            console.log(LocationssData);

        } catch (error) {
            console.error("Error fetching Locations:", error);
        }
    }


    useEffect(() => {
        // قم بإجراء طلب HTTP لجلب العقارات


        // استدعاء الدالة لجلب البيانات
        fetchLocations();
    }, []);

    const array = {
        "data": [
            {
                "id": "1",
                "attributes": {
                    "name": "rerum",
                    "image": "https://via.placeholder.com/640x480.png/0044ee?text=neque"
                }
            },
            {
                "id": "2",
                "attributes": {
                    "name": "porro",
                    "image": "https://via.placeholder.com/640x480.png/007700?text=dolorum"
                }
            },
            {
                "id": "3",
                "attributes": {
                    "name": "dolorum",
                    "image": "https://via.placeholder.com/640x480.png/0099cc?text=cupiditate"
                }
            },
            {
                "id": "4",
                "attributes": {
                    "name": "voluptatem",
                    "image": "https://via.placeholder.com/640x480.png/0033cc?text=cumque"
                }
            },
            {
                "id": "6",
                "attributes": {
                    "name": "perferendis",
                    "image": "https://via.placeholder.com/640x480.png/0033bb?text=ipsum"
                }
            },
            {
                "id": "7",
                "attributes": {
                    "name": "incidunt",
                    "image": "https://via.placeholder.com/640x480.png/00bbaa?text=nobis"
                }
            },
            {
                "id": "8",
                "attributes": {
                    "name": "et",
                    "image": "https://via.placeholder.com/640x480.png/00cc11?text=provident"
                }
            },
            {
                "id": "9",
                "attributes": {
                    "name": "vel",
                    "image": "https://via.placeholder.com/640x480.png/00aaff?text=laudantium"
                }
            },
            {
                "id": "10",
                "attributes": {
                    "name": "delectus",
                    "image": "https://via.placeholder.com/640x480.png/00aacc?text=omnis"
                }
            },
            {
                "id": "11",
                "attributes": {
                    "name": "maxime",
                    "image": "https://via.placeholder.com/640x480.png/005522?text=consequatur"
                }
            },
            {
                "id": "12",
                "attributes": {
                    "name": "voluptates",
                    "image": "https://via.placeholder.com/640x480.png/00cc66?text=velit"
                }
            },
            {
                "id": "13",
                "attributes": {
                    "name": "sequi",
                    "image": "https://via.placeholder.com/640x480.png/004477?text=in"
                }
            },
            {
                "id": "14",
                "attributes": {
                    "name": "doloremque",
                    "image": "https://via.placeholder.com/640x480.png/00ee11?text=ullam"
                }
            },
        ]
    };

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
        // يمكنك هنا تنفيذ البحث باستخدام searchTerm
        console.log('تم البحث عن:', searchTerm);
    };

    const handleEdit = (item) => {
        router.push(`/Locations/Edit/?id=${item.id}`);
        console.log(item);
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
                    title="عدد المواقع"
                    value="30"
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
                    data={locations}
                    onEdit={handleEdit}
                    onDelete={handleDelete} />
            </div>
        </Layout>
    )
}
