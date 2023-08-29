// Update.js

import TextBox from "@/Components/FormsComponents/Inputs/TextBox"
import api from "@/api/api"
import Layout from "@/layout/Layout"
import { useRouter } from "next/router"
import { useEffect, useState } from "react"
import { toast } from "react-toastify"

import LoadingIndicator from "@/utils/LoadingIndicator "
import qs from "qs"

export default function Update() {
  const [loading, setLoading] = useState(false)
  const router = useRouter()
  const { id } = router.query

  const [formData, setFormData] = useState({
    name: "",
  })

  const [oldformData, setOldformData] = useState({
    name: "",
  })
  const handleUpdate = async () => {
    const authToken = localStorage.getItem("authToken")
    try {
      if (
        formData.name != "" &&
        formData.name &&
        formData.name != oldformData.name
      ) {
        const formDataForApi = {
          name: formData.name,
        }
        const encodedData = qs.stringify(formDataForApi)
        await api.put(`locations/location/${id}`, encodedData, authToken)
        toast.success("تم تحديث البيانات بنجاح")
        router.push("/Locations")
      } else {
        toast.warning("لم تقم بتعديل اي شيء")
        router.push("/Locations")
      }
    } catch (error) {
      console.error("Error updating data:", error)
      toast.error("حدث خطأ أثناء التحديث")
    }
  }

  useEffect(() => {
    // Fetch existing data and populate the form
    const fetchData = async () => {
      try {
        const authToken = localStorage.getItem("authToken")
        const locationData = await api.get(
          `locations/location/${id}`,
          authToken
        )
        setFormData({ name: locationData.attributes.name })
        setOldformData({ name: locationData.attributes.name })
      } catch (error) {
        console.error("Error fetching existing data:", error)
      }
      setLoading(true)
    }
    fetchData()
  }, [id])

  return (
    <>
      {!loading ? (
        <LoadingIndicator />
      ) : (
        <Layout>
          <div className='flex mt-5 flex-col w-full items-center justify-between pb-4 bg-white dark:bg-white rounded-md text-black'>
            <div className='flex items-center space-x-4 w-full p-4' dir='rtl'>
              <form className='w-full '>
                <TextBox
                  type='text'
                  id='name'
                  label='اسم الموقع'
                  name='name'
                  placeholder='ادخل اسم الموقع'
                  value={formData.name}
                  onChange={(e) =>
                    setFormData({ ...formData, name: e.target.value })
                  }
                />
                <button
                  className={`bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600`}
                  type='button'
                  onClick={handleUpdate}
                >
                  تحديث
                </button>
              </form>
            </div>
          </div>
        </Layout>
      )}
    </>
  )
}
