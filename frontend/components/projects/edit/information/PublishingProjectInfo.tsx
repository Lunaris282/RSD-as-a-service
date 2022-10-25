import Alert from '@mui/material/Alert'
import AlertTitle from '@mui/material/AlertTitle'
import Link from 'next/link'

export default function PublishingProjectInfo() {
  return (
    <Alert
        severity="info"
        sx={{
          marginTop:'1rem'
        }}
      >
        <AlertTitle>Publishing project page</AlertTitle>
        Setting the page status to published will expose the project page to public.
        Not published project can be found under <strong>
          <Link href="/user/projects"><a>your profile</a></Link>
        </strong> page.
      </Alert>
  )
}
