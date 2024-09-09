import React, { Fragment, useEffect } from 'react';
import { ApolloClient, InMemoryCache, gql } from '@apollo/client';

const MapManager = ({ selectedYear = 2016 }) => {
    useEffect(() => {
      callAPI(selectedYear);
    }, [selectedYear]);

    function callAPI() {
      const tokenEl = document.getElementsByName('csrf-token')[0]
      let token = ""
      if (tokenEl) {
        token = tokenEl.getAttribute('content')
      }
      const client = new ApolloClient({
        uri: './graphql',
        cache: new InMemoryCache(),
        headers: {
          'X-CSRF-Token': token
        }
      });
      client
        .query({
          query: GET_ADOPTIONS,
          variables: { year: selectedYear.toString() }
        })
        .then(result => {
            const adoptions = result.data.adoption;
            let mapdata = {}
            adoptions.forEach((county) => {
                mapdata[county.mapId] = { color: county.color, name: county.county, description: county.count + " adoptions" }  
            })
            simplemaps_statemap_mapdata.state_specific = mapdata;
            simplemaps_statemap.load()
        });
    }
    
    return (
        <Fragment></Fragment>
    );
  };
  
  export const GET_ADOPTIONS = gql`
    query getAdoptions($year: String!) {
      adoption(year: $year) {
        count
        county
        color
        mapId
      }
    }
  `;
  
  export default MapManager;
  