import React, { useState } from 'react';
import * as style from './Map.module.css';
import { ApolloClient, InMemoryCache, gql } from '@apollo/client';

const InternalMap = (props) => {
    const [ adoptions, setAdoptions ] = useState([]);
    function callAPI(year) {
      const client = new ApolloClient({
        uri: './graphql',
        cache: new InMemoryCache()
      });
      client
        .query({
          query: GET_ADOPTIONS,
          variables: { year: year }
        })
        .then(result => {
            const adoptions = result.data.adoption;
            setAdoptions(adoptions);
            let mapdata = {}
            adoptions.forEach((county) => {
                mapdata[county.mapId] = { color: county.color, name: county.county, description: county.count + " adoptions" }  
            })
            simplemaps_statemap_mapdata.state_specific = mapdata;
            simplemaps_statemap.load()
        });

        //simplemaps_statemap.load()
    }
    
    return (
        <div>
          <h3>Hello!</h3>
          <hr />
            <button onClick={(e) => callAPI("2014")}>2014</button>
            <button onClick={(e) => callAPI("2015")}>2015</button>
            <button onClick={(e) => callAPI("2016")}>2016</button>
            <button onClick={(e) => callAPI("2017")}>2017</button>
            <button onClick={(e) => callAPI("2018")}>2018</button>
            <button onClick={(e) => callAPI("2019")}>2019</button>
            <button onClick={(e) => callAPI("2020")}>2020</button>
            <button onClick={(e) => callAPI("2021")}>2021</button>
            <button onClick={(e) => callAPI("2022")}>2022</button>
            <button onClick={(e) => callAPI("2023")}>2023</button>
        </div>
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
  
  export default InternalMap;
  