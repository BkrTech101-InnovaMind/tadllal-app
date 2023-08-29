import { Slider } from "@/Components/Slider"
import Layout from "@/layout/Layout"
import { useRouter } from "next/router"

function formatDate(dateString) {
  const date = new Date(dateString)
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, "0") // Months are 0-indexed
  const day = String(date.getDate()).padStart(2, "0")
  return `${year}/${month}/${day}`
}

export default function Details() {
  const router = useRouter()
  const { query } = router
  let jsonData = null
  if (query.jsonData) {
    try {
      jsonData = JSON.parse(query.jsonData)
    } catch (error) {
      console.error("Error parsing JSON data", error)
    }
  }
  const realEstateData = jsonData
  const extractedDate = formatDate(realEstateData.attributes.date)
  return (
    <Layout>
      <div
        className='mt-5 w-[90%] items-center text-center pb-4 bg-white dark:bg-white text-black'
        dir='ltr'
      >
        {/* Image Slider */}
        <div className='border-2 border-gray-300 w-[100%]'>
          <Slider
            images={realEstateData.attributes.images}
            name={realEstateData.attributes.name}
          />
        </div>
        {/* Real Estate Attributes */}
        <div className='text-black'>
          {/* Real Estate Name */}
          <div>
            <h1 className='text-3xl font-extrabold mt-16 mb-6'>إسم العقار:</h1>
            <h1 className='text-2xl'>{realEstateData.attributes.name}</h1>
          </div>
          {/* Real Estate Description */}
          <div>
            <h1 className='text-3xl font-bold mt-16 mb-6'>الوصف:</h1>
            <h1 className='text-2xl'>
              {realEstateData.attributes.description}
            </h1>
          </div>
          {/* Real Estate Price & Location */}
          <div>
            <h1 className='text-2xl font-bold mt-16 mb-6'>السعر & الموقع</h1>
            <div className='flex justify-around text-xl'>
              <span className='max-w-full lg:max-w-[40%]'>
                <h1>
                  <span>
                    <i class='fa fa-location-arrow' aria-hidden='true'></i>
                  </span>
                  &nbsp;{realEstateData.attributes.locationInfo}
                </h1>
              </span>
              <h1 className='text-2xl'>
                <span className='font-bold'>$ </span>
                {realEstateData.attributes.price}
              </h1>
            </div>
          </div>
          {/* Real Estate Types */}
          <div>
            <h1 className='text-2xl font-bold mt-16 mb-6'>النوع & الحالة</h1>
            <div className='flex justify-around text-3xl'>
              <h1>{realEstateData.attributes.secondType}</h1>
              <h1>{realEstateData.attributes.firstType.name}</h1>
            </div>
          </div>
          {/* Real Estate Rating */}
          <div>
            <h1 className='text-2xl font-bold mt-16 mb-6'>
              إجمالي التقييمات & التقييم النهائي
            </h1>
            <div className='flex justify-around text-3xl'>
              <h1>{realEstateData.attributes.ratings.average_rating}</h1>
              <h1>{realEstateData.attributes.ratings.rating_count}</h1>
            </div>
          </div>
          {/* Real Estate Date & State */}
          <div>
            <h1 className='text-2xl font-bold mt-16 mb-6'>
              الإتاحة & تاريخ النشر
            </h1>
            <div className='flex justify-around text-3xl'>
              <h1>{extractedDate}</h1>
              <h1>{realEstateData.attributes.state}</h1>
            </div>
          </div>
        </div>
      </div>
    </Layout>
  )
}
