import Button from '@mui/material/Button'

import {contributorInformation as config} from '../editSoftwareConfig'

export default function GetContributorsFromDoi(
  {onClick}: { onClick: () => void }
) {
  return (
    <Button
      variant="outlined"
      onClick={onClick}
    >
      { config.importContributors.label }
    </Button>
  )
}
