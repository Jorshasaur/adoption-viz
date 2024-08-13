import React from 'react';
import { ApolloClient, InMemoryCache, ApolloProvider, gql } from '@apollo/client';
import InternalMap from './InternalMap';

const Map = (props) => {
  const client = new ApolloClient({
    uri: './graphql',
    cache: new InMemoryCache()
  });

  return (
    <ApolloProvider client={client}>
      <InternalMap />
    </ApolloProvider>
  );
};

export default Map;
