import React, { useState } from 'react';
import * as style from './Map.module.css';
import { ApolloClient, InMemoryCache, gql } from '@apollo/client';

const InternalMap = (props) => {
    const [ adoptions, setAdoptions ] = useState([]);
    function callAPI() {
      const client = new ApolloClient({
        uri: './graphql',
        cache: new InMemoryCache()
      });
      client
        .query({
          query: GET_ADOPTIONS,
          variables: { year: '2020' }
        })
        .then(result => {
            setAdoptions(result.data.adoption);
        });

        //simplemaps_statemap.load()
    }
    
    return (
        <div>
          <h3>Hello!</h3>
          <hr />
          <form>
            <label className={style.bright} htmlFor="name">
              Say hello to:
              <input id="name" type="text" onChange={(e) => callAPI() } />
            </label>
          </form>
          <div id="map"></div>
          <div>{adoptions.map((county, index) => {
                return <div key={"county_"+ index}>{county.number} adoptions in {county.county}</div>
          })}</div>
        </div>
    );
  };
  
  export const GET_ADOPTIONS = gql`
    query getAdoptions($year: String!) {
      adoption(year: $year) {
        number
        county
      }
    }
  `;
  
  export default InternalMap;
  