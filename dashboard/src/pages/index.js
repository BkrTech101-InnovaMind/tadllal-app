// import Card from '@/Components/Card'
import Card from "@/Components/Card"
import api from "@/api/api"
import Layout from "@/layout/Layout"
import { useEffect, useState } from "react"
import { BsHouseDoor } from "react-icons/bs"

export default function Home() {
  const [statistics, setStatistics] = useState([])
  const [loading, setLoading] = useState(false)
  useEffect(() => {
    async function fetchStatistics() {
      const authToken = localStorage.getItem("authToken")
      try {
        const statisticsData = await api.get("statistics", authToken)
        setStatistics(statisticsData.statistics)
        console.log(statistics)
      } catch (error) {
        console.error("Error fetching real estates:", error)
      }
      setLoading(true)
    }
    fetchStatistics()
  }, [])

  const columns = [
    { key: "id", label: "الرقم" },
    {
      key: "attributes",
      label: "العقار",
      render: (item) => (
        <div className='flex items-center'>
          <Image
            width={50}
            height={50}
            className='w-10 h-10 rounded-full ml-2'
            src={
              item.attributes.photo.startsWith("storage")
                ? `http://127.0.0.1:8000/${item.attributes.photo}`
                : item.attributes.photo
            }
            alt='Jese image'
          />
          <div className='pl-3'>
            <div className='text-base font-semibold'>
              {item.attributes.name}
            </div>
            <div className='font-normal text-gray-500'>
              {item.attributes.firstType.name}/
              {item.attributes.secondType == "for rent" ? "للايجار" : "للبيع"}
            </div>
          </div>
        </div>
      ),
    },
    {
      key: "location",
      label: "الموقع",
      render: (item) => (
        <div>
          {item.attributes.location.name}/{item.attributes.locationInfo}
        </div>
      ),
    },
    {
      key: "price",
      label: "السعر",
      render: (item) => <div>{item.attributes.price}</div>,
    },
    {
      key: "statues",
      label: "الحالة",
      render: (item) => (
        <div className='flex items-center'>
          <select
            className={
              item.attributes.state === "available"
                ? "text-green-700"
                : "text-red-700"
            }
            value={item.attributes.state}
            onChange={(e) => handleDropdownChange(e.target.value, item.id)}
          >
            {item.attributes.state === "available" ? (
              <>
                <option value='available' style={{ color: "#34D399" }} disabled>
                  متاح
                </option>
                <option value='Unavailable' style={{ color: "#EF4444" }}>
                  غير متاح
                </option>
              </>
            ) : (
              <>
                <option
                  value='Unavailable'
                  style={{ color: "#EF4444" }}
                  disabled
                >
                  غير متاح
                </option>
                <option value='available' style={{ color: "#34D399" }}>
                  متاح
                </option>
              </>
            )}
          </select>
        </div>
      ),
    },
  ]
  return (
    <Layout>
      <div
        className='grid grid-cols-4 my-0 gap-4 md:grid-cols-1 py-0 text-black w-full'
        dir='rtl'
      >
        <Card
          id='1'
          icon={<BsHouseDoor size={69} color='#f584' />}
          title='عدد العقارات'
          value={statistics.realEstatesCount}
          label='العدد الاجمالي'
        />
        <Card
          id=''
          icon={<BsHouseDoor size={69} color='#f584' />}
          title='العقارات الخدمات'
          value={statistics.totalServices}
          label='العدد الاجمالي'
        />
        <Card
          id='1'
          icon={<BsHouseDoor size={69} color='#f584' />}
          title=' طلبات العقارات'
          value={statistics.realEstateOrdersCount}
          label='العدد الاجمالي'
        />
        <Card
          id='1'
          icon={<BsHouseDoor size={69} color='#f584' />}
          title=' طلبات الخدمات'
          value={statistics.serviceOrdersCount}
          label='العدد الاجمالي'
        />
      </div>

      <div
        className='grid grid-cols-4 my-0 gap-4 md:grid-cols-1 py-0 text-black w-full'
        dir='rtl'
      >
        {/* <CustomTable
          columns={columns}
          data={statistics.latestRealEstateOrders}
  
        />
        <CustomTable
          columns={columns}
          data={statistics.latestServiceOrders}

        /> */}
        {/* <CustomTable columns={columns} data={statistics.latestRealEstates} /> */}
      </div>
    </Layout>
  )
}
