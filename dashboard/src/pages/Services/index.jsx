import Card from "@/Components/Card"
import CustomTable from "@/Components/CustomTable"
import PrimaryBt from "@/Components/FormsComponents/Buttons/PrimaryBt"
import DropDownList from "@/Components/FormsComponents/Inputs/DropDownList"
import Search from "@/Components/FormsComponents/Inputs/Search"
import api from "@/api/api"
import { tableSearch } from "@/api/filtersData"
import Layout from "@/layout/Layout"
import Image from "next/image"
import Link from "next/link"
import { useRouter } from "next/router"
import { useEffect, useState } from "react"
import { BsHouseDoor } from "react-icons/bs"
import { toast } from "react-toastify"
export default function Index() {
  const router = useRouter()
  const [services, setServices] = useState([])
  const [subServices, setSubServices] = useState([])
  const [data, setData] = useState([])

  const [searchResults, setSearchResults] = useState([])
  const [endpoint, setEndpoint] = useState("services/services/")

  async function fetchTypes() {
    const authToken = localStorage.getItem("authToken")

    try {
      const servicesData = await api.get(endpoint, authToken)
      setServices(servicesData)
      const subServicesData = await api.get("subServices/services/", authToken)
      setSubServices(subServicesData)
    } catch (error) {
      console.error("Error fetching Types:", error)
    }
  }

  useEffect(() => {
    setData(services)
  }, [services])
  useEffect(() => {
    fetchTypes()
  }, [])

  const handleOptionSelect = (selectedId) => {
    if (selectedId == 1) {
      setEndpoint("services/services/")
      setSearchResults("")
      setData(services)
    } else if (selectedId == 2) {
      setEndpoint("subServices/services/")
      setSearchResults("")
      setData(subServices)
    }
    // fetchTypes();
    console.log(`Selected ID: ${selectedId}`)
  }
  const array = {
    data: [
      {
        id: "1",
        attributes: {
          name: "الخدمات الرئيسية",
        },
      },
      {
        id: "2",
        attributes: {
          name: "الخدمات الفرعية",
        },
      },
    ],
  }

  const columns1 = [
    { key: "id", label: "الرقم" },
    {
      key: "property",
      label: "الخدمة",
      render: (item) => (
        <div className='flex items-center'>
          <Image
            width={50}
            height={50}
            className='w-10 h-10 rounded-full ml-2'
            src={
              item.attributes.image.startsWith("storage")
                ? `http://127.0.0.1:8000/${item.attributes.image}`
                : item.attributes.image
            }
            alt='Jese image'
          />
          <div className='pl-3'>
            <div className='text-base font-semibold'>
              {item.attributes.name}
            </div>
          </div>
        </div>
      ),
    },
    {
      key: "attributes",
      label: "وصف الخدمة",
      render: (item) => <div>{item.attributes.description}</div>,
    },
    {
      key: "sub_services_count",
      label: "عدد الخدمات الفرعية",
      render: (item) =>
        // عرض الوصف إذا كان متوفرًا، وإلا عرض رسالة بدلاً منه
        item.sub_services_count ? <div>{item.sub_services_count}</div> : 0,
    },
  ]
  const columns2 = [
    { key: "id", label: "الرقم" },
    {
      key: "property",
      label: "الخدمة",
      render: (item) => (
        <div className='flex items-center'>
          <Image
            width={50}
            height={50}
            className='w-10 h-10 rounded-full ml-2'
            src={
              item.attributes.image.startsWith("storage")
                ? `http://127.0.0.1:8000/${item.attributes.image}`
                : item.attributes.image
            }
            alt='Jese image'
          />
          <div className='pl-3'>
            <div className='text-base font-semibold'>
              {item.attributes.name}
            </div>
          </div>
        </div>
      ),
    },
    {
      key: "attributes",
      label: "وصف الخدمة",
      render: (item) => <div>{item.attributes.description}</div>,
    },
    {
      key: "construction",
      label: "الخدمة الرئيسية", // إضافة الحقل "وصف الخدمة"
      render: (item) =>
        // عرض الوصف إذا كان متوفرًا، وإلا عرض رسالة بدلاً منه
        item.attributes.construction ? (
          <div>{item.attributes.construction}</div>
        ) : null,
    },
  ]

  const handleSearch = (searchTerm) => {
    const searchedField = "name" // تعيين الحقل الذي ترغب في البحث فيه
    const filteredResults = tableSearch(searchTerm, data, searchedField)
    setSearchResults(filteredResults)
  }

  const handleEdit = (item) => {
    if (endpoint == "services/services/") {
      router.push(`Services/Edit?id=${item.id}`)
    } else {
      router.push(`Services/Sub/Edit?id=${item.id}`)
    }
  }

  const handleDelete = async (item) => {
    const authToken = localStorage.getItem("authToken")

    data
    try {
      await api.deleteFunc(`${endpoint}${item.id}`, authToken)

      const updatedServices = data.filter((service) => service.id !== item.id)

      setData(updatedServices)
      if (endpoint == "services/services/") {
        setServices(updatedServices)
      } else {
        setSubServices(updatedServices)
      }
      toast.success("تم حذف الخدمة بنجاح")
    } catch (error) {
      console.log(error)
      toast.error("خطأ أثناء حذف الخدمة")
    }
  }

  function handleView(items) {}

  return (
    <Layout>
      {/* // page container */}
      <div
        className='grid grid-cols-4 my-0 gap-4 md:grid-cols-1 py-0 text-black w-full'
        dir='rtl'
      >
        <Card
          id='1'
          icon={<BsHouseDoor size={69} color='#f584' />}
          title='عدد كل الخدمات'
          value={services.length + subServices.length}
          label='العدد الاجمالي'
        />
        <Card
          id='1'
          icon={<BsHouseDoor size={69} color='#f584' />}
          title='عدد الخدمات الرئيسية'
          value={services.length}
          label='العدد الاجمالي'
        />

        <Card
          id='1'
          icon={<BsHouseDoor size={69} color='#f584' />}
          title='عدد الخدمات الفرعية'
          value={subServices.length}
          label='العدد الاجمالي'
        />
      </div>
      <div className='flex mt-5 flex-col w-full items-center justify-between pb-4 bg-white dark:bg-white rounded-md text-black'>
        {/* filter container */}

        <div className='flex items-center space-x-4 w-full p-4' dir='rtl'>
          <div className='flex flex-col gap-y-4 w-full'>
            <div>
              <p>خيارات العرض</p>
            </div>
            <div className='flex w-full '>
              <DropDownList
                title='عرض الخدمات'
                options={array.data}
                onSelect={handleOptionSelect}
              />

              {/* <DropDownList />
							<DropDownList />
							<DropDownList /> */}
            </div>
            <div className='flex justify-between border-t-2 pt-5'>
              <div>
                {/* <PrimaryBt type="add" name="إضافة عقار جديد" onClick={() => { }} /> */}
                <Link href='/Services/New'>
                  <PrimaryBt type='add' name='إضافة خدمة رئيسية جديدة' />
                </Link>
                <Link href='/Services/Sub/New'>
                  <PrimaryBt type='add' name='إضافة خدمة فرعية جديدة' />
                </Link>
                <PrimaryBt type='export' name='تصدير' onClick={() => {}} />
              </div>

              <div>
                <Search onSearch={handleSearch} />
              </div>
            </div>
          </div>
        </div>
        {/* <Table /> */}
        {endpoint == "services/services/" ? (
          <CustomTable
            columns={columns1}
            data={searchResults.length > 0 ? searchResults : data}
            onEdit={handleEdit}
            onDelete={handleDelete}
            extraButtonType={"view"}
            myFunction={handleView}
          />
        ) : (
          <CustomTable
            columns={columns2}
            data={searchResults.length > 0 ? searchResults : data}
            onEdit={handleEdit}
            onDelete={handleDelete}
          />
        )}
      </div>
    </Layout>
  )
}
