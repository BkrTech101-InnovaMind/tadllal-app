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
export default function Index() {
    const router = useRouter();
    const [types, setTypes] = useState([]);

    async function fetchTypes() {
        const authToken = localStorage.getItem('authToken');
        try {
            const typesData = await api.get('types/types', authToken);
            setTypes(typesData);
        } catch (error) {
            console.error('Error fetching Types:', error);
        }
    }


    const handleOptionSelect = (selectedId) => {
        console.log(`Selected ID: ${selectedId}`);
    };

    useEffect(() => {

        fetchTypes();
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

    const data = [
        {
            number: 1,

            name: "فيلا",
            property: {
                imageSrc: "https://via.placeholder.com/640x480.png/00ee11?text=ullam",
            }



        }, {
            number: 2,

            name: "فيلا",
            property: {
                imageSrc: "https://via.placeholder.com/640x480.png/00ee11?text=ullam",
            }



        },

    ];
    const handleSearch = (searchTerm) => {
        // يمكنك هنا تنفيذ البحث باستخدام searchTerm
        console.log('تم البحث عن:', searchTerm);
    };

    const handleEdit = (item) => {
        router.push(`Types/Edit?id=${item.id}`);
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
                    title="عدد أنواع العقارات"
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
                    data={types}
                    onEdit={handleEdit}
                    onDelete={handleDelete} />
            </div>
        </Layout>
    )
}
