import "@/styles/globals.css"
import LoadingIndicator from "@/utils/LoadingIndicator"
import axios from "axios"
import { useRouter } from "next/router"
import { useEffect, useState } from "react"
import { ToastContainer } from "react-toastify"
import "react-toastify/dist/ReactToastify.css"
const API_URL = "http://127.0.0.1:8000/api/"
export default function App({ Component, pageProps }) {
  const [user, setUser] = useState(null)
  const router = useRouter()
  const [loading, setLoading] = useState(false)
  async function checkUserStatus() {
    const headers = {
      "Content-Type": `application/vnd.api+json`,
      Accept: `application/vnd.api+json`,
      Authorization: `Bearer ${localStorage.getItem("authToken")}`,
    }
    try {
      const response = await axios.get("user", {
        baseURL: API_URL,
        headers: headers,
      })
      const userData = response.data
      setUser(userData)
    } catch (error) {
      setUser(null)
    }
    setLoading(true)
    if (
      !localStorage.getItem("authToken") &&
      !user &&
      router.pathname !== "/Login"
    ) {
      router.push("/Login")
    }
    if (
      localStorage.getItem("authToken") &&
      user &&
      router.pathname === "/Login"
    ) {
      router.push("/")
    }
  }

  useEffect(() => {
    checkUserStatus()
  }, [router.pathname, router])

  return (
    <>
      {!loading ? (
        <LoadingIndicator />
      ) : (
        <>
          <Component {...pageProps} />
          <ToastContainer />
        </>
      )}
    </>
  )
}

// import "../styles/globals.css"

// import { AuthChecker } from "@/utils/AuthChecker"
// import ErrorBoundary from "@/utils/ErrorBundary"
// import { StoreProvider } from "@/utils/store"

// function MyApp({ Component, pageProps }) {
//   return (
//     <div className='bg-iceblue'>
//       <ErrorBoundary>
//         <StoreProvider>
//           <AuthChecker Component={Component} pageProps={pageProps} />
//         </StoreProvider>
//       </ErrorBoundary>
//     </div>
//   )
// }

// export default appWithTranslation(MyApp)
