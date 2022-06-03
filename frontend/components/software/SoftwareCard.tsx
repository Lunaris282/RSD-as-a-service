// SPDX-FileCopyrightText: 2021 - 2022 Dusan Mijatovic (dv4all)
// SPDX-FileCopyrightText: 2021 - 2022 dv4all
//
// SPDX-License-Identifier: Apache-2.0

import Link from 'next/link'
import StarIcon from '@mui/icons-material/Star'
import {getTimeAgoSince} from '../../utils/dateFn'

export type SoftwareCardType = {
  href: string
  brand_name: string
  short_statement: string,
  is_featured: boolean,
  updated_at: string | null
}

export default function SoftwareCard({href,brand_name,short_statement,is_featured,updated_at}:SoftwareCardType) {

  const colors = is_featured ? 'bg-primary text-white' : 'bg-grey-100 text-gray-800'
  const today = new Date()

  function getInitals() {
    if (brand_name) {
      return brand_name.slice(0,2).toUpperCase()
    }
    return ''
  }

  function renderFeatured(){
    if (is_featured){
      return (
        <div className="flex items-start justify-center">
          <StarIcon sx={{height:'1rem'}} />
          Featured
        </div>
      )
    }
  }

  return (
    <Link href={href} passHref>
      <a className="flex flex-col h-full">
        <article className={`flex-1 flex flex-col ${colors} hover:bg-secondary hover:text-white`}>
          <div className="flex relative">
            <h2
              title={brand_name}
              className="p-4 flex-1 mr-[4rem] overflow-hidden text-ellipsis whitespace-nowrap"
            >
              {brand_name}
            </h2>
            <div
              className="flex w-[4rem] h-[4rem] justify-center items-center bg-white text-gray-800 text-[1.5rem]"
              style={{position:'absolute',right:0,top:0}}
            >
              {getInitals()}
            </div>
          </div>
          <p className="flex-1 p-4 overflow-auto max-h-[9.75rem]">
            {short_statement}
          </p>
          <div className="flex justify-between p-4 text-sm">
            <span className="last-update">
              {getTimeAgoSince(today,updated_at)}
            </span>
            {renderFeatured()}
          </div>
        </article>
      </a>
    </Link>
  )
}
