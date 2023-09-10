import Card from "@/Components/Card"
import CustomTable from "@/Components/CustomTable"
import PrimaryBt from "@/Components/FormsComponents/Buttons/PrimaryBt"
import DropDownList from "@/Components/FormsComponents/Inputs/DropDownList"
import Search from "@/Components/FormsComponents/Inputs/Search"
import api from "@/api/api"
import { fetchLocations, fetchTypes } from "@/api/fetchData"
import { countMatchingItems, filterRealEstatesByPrice } from "@/api/filtersData"
import { realEstateTypes, status } from "@/data/arrays"
import Layout from "@/layout/Layout"
import LoadingIndicator from "@/utils/LoadingIndicator "
import Image from "next/image"
import Link from "next/link"
import { useRouter } from "next/router"
import { useEffect, useState } from "react"
import { GiCash, GiHouse, GiHouseKeys, GiKeyLock } from "react-icons/gi"
import { toast } from "react-toastify"

export default function index() {
    const [loading, setLoading] = useState(false)
    const [customers, setCustomers] = useState([])
    const [searchResults, setSearchResults] = useState([])

    async function fetchCustomers() {
        const authToken = localStorage.getItem("authToken")
        try {
            const customersData = await api.get('customerRequests/getAllCustomerRequests', authToken)
            setCustomers(customersData)
            console.log(customersData);
        } catch (error) {
            console.error("Error fetching orders:", error)
        }
        setLoading(true)
    }

    useEffect(() => {
        fetchCustomers()
    }, [])


    const columns = [
        { key: "id", label: "الرقم" },
        {
            key: "realEstate",
            label: "العقار",
            render: (item) => (
                <div>
                    {item.attributes.property}
                </div>
            ),
        },
        {
            key: "user",
            label: "مقدم الطلب",
            render: (item) => (
                <div className='flex items-center'>
                    <Image
                        width={50}
                        height={50}
                        className='w-10 h-10 rounded-full ml-2'
                        src={item.attributes.user.userImage}
                        alt='Jese image'
                    />
                    <div className='pl-3'>
                        <div className='text-base font-semibold'>{item.attributes.user.name}</div>
                        <div className='font-normal text-gray-500'>{item.attributes.user.email}</div>
                        <div className='font-normal text-gray-500'>
                            {item.attributes.user.phoneNumber}
                        </div>
                    </div>
                </div>
            ),
        },
        {
            key: "customer",
            label: "العميل",
            render: (item) => <div className='flex flex-col'>
                <div>{item.attributes.customer.name}</div>
                <div>{item.attributes.customer.phone_number}</div>
            </div>,
        },
        {
            key: "location",
            label: "الموقع ",
            render: (item) => <div>{item.attributes.location.name}</div>,
        },
        {
            key: "type",
            label: "النوع ",
            render: (item) => <div>{item.attributes.type.name}</div>,
        },
        {
            key: "budget",
            label: "الميزانية",
            render: (item) => <div dir="ltr">{item.attributes.budget.from} - {item.attributes.budget.to} {item.attributes.budget.currency}</div>,
        },
        {
            key: "message",
            label: "تفاصيل الطلب ",
            render: (item) => <div>{item.attributes.other_details}</div>,
        },

        {
            key: "status",
            label: "حالة الطلب  ",
            render: (item) => <div>{item.attributes.request_status}</div>,
        },

        {
            key: "communication",
            label: "حالة التواصل  ",
            render: (item) => <div>{item.attributes.communication_status}</div>,
        },

    ]


    const handleSearch = (searchTerm) => {
        const filteredResults = searchOrders(searchTerm, data, endpoint)
        setSearchResults(filteredResults)
        console.log("تم البحث عن:", searchTerm)
    }

    const handleStateChangeChange = async (e, itemId) => {
        const authToken = localStorage.getItem("authToken")
        try {
            const formDataForApi = new FormData()
            formDataForApi.append("state", e)
            const response = await api.post(
                `realEstate/${itemId}/edit`,
                formDataForApi,
                authToken
            )
            toast.success("تم تحديث حالة العقار بنجاح")
            const updatedRealEstates = realEstates.map((estate) => {
                if (estate.id === itemId) {
                    return { ...estate, attributes: { ...estate.attributes, state: e } }
                }
                return estate
            })
            setRealEstates(updatedRealEstates)
        } catch (error) {
            console.error("Error updating realty data:", error)
            toast.error("حدث خطأ أثناء تحديث البيانات.")
        }
    }
    return (
        <>
            {!loading ? (
                <LoadingIndicator />
            ) : (
                <Layout>
                    {/* // page container */}
                    <div
                        className='grid grid-cols-4 my-0 gap-4 md:grid-cols-1 py-0 text-black w-full'
                        dir='rtl'
                    >
                        {/* <Card
                  id='1'
                  icon={<BiHomeAlt size={69} color='#3498db' />} // أيقونة تمثيل طلبات العقارات مع لون أزرق ملائم
                  title='طلبات العقارات'
                  value={orders.length}
                  label='العدد الاجمالي'
                  color='#3498db'
                />
                <Card
                  id=''
                  icon={<FaToolbox size={69} color='#e67e22' />} // أيقونة تمثيل طلبات الخدمات مع لون برتقالي ملائم
                  title='طلبات الخدمات'
                  value={sevices.length}
                  label='العدد الاجمالي'
                  color='#e67e22'
                />
                <Card
                  id='1'
                  icon={<IoMdCheckmarkCircle size={69} color='#27ae60' />} // أيقونة تمثيل الموافق عليها مع لون أخضر ملائم
                  title='الموافق عليها'
                  value={getApprovedServicesCount() + getApprovedOrdersCount()}
                  label='العدد الاجمالي'
                  color='#27ae60'
                /> */}
                        {/* <Card
                  id='1'
                  icon={<HiOutlineClipboardCheck size={69} color='#f39c12' />} // أيقونة تمثيل تحت المراجعة مع لون أصفر ملائم
                  title='تحت المراجعة'
                  value={
                    getUnderReviewServicesCount() + getUnderReviewOrdersCount()
                  }
                  label='العدد الاجمالي'
                  color='#f39c12'
                /> */}
                    </div>
                    <div className='flex mt-5 flex-col w-full items-center justify-between pb-4 bg-white dark:bg-white rounded-md text-black'>
                        {/* filter container */}

                        <div className='flex items-center space-x-4 w-full p-4' dir='rtl'>
                            <div className='flex flex-col gap-y-4 w-full'>
                                <div>
                                    <p>خيارات البحث</p>
                                </div>
                                <div className='flex w-full '>
                                    {/* <DropDownList
                        title='اختر نوع الطلب'
                        options={array.data}
                        onSelect={handleOptionSelect}
                      />
                      <DropDownList
                        title='اختر حالة الطلب'
                        options={array2.data}
                        onSelect={handleStatusSelect}
                      />
    
                      {/* <DropDownList />
                                <DropDownList />
                                <DropDownList /> */}
                                </div>
                                <div className='flex justify-between border-t-2 pt-5'>
                                    <div>
                                        {/* <PrimaryBt type="add" name="إضافة عقار جديد" onClick={() => { }} /> */}
                                        <Link href='/RealEstate/New'>
                                            <PrimaryBt type='add' name='إضافة عقار جديد' />
                                        </Link>
                                        <PrimaryBt type='export' name='تصدير' onClick={() => { }} />
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
                            data={searchResults.length > 0 ? searchResults : customers}
                            onEdit={null}
                            onDelete={null}
                        />

                    </div>
                </Layout>
            )}
        </>
    )
}
