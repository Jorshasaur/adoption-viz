import React, { useState, Fragment } from 'react';
import YearSelector from './YearSelector';
import MapManager from './MapManager';

const MapControls = () => {
    const [selectedYear, setSelectedYear] = useState(2016);

  return (
    <Fragment>
        <div className="columns-2 pl-12 pr-8 pt-32 pb-4 test">
            <h1 className="text-3xl text-gray-800 font-sans font-bold">Successful Adoptions by County</h1>
            <YearSelector selectedYear={selectedYear} selectedYearChanger={(year) => setSelectedYear(year)} />
        </div>

        <p className="text-huge font-extrabold my-0 mx-0 px-0 py-0 text-gray-100">{selectedYear}</p>
        <MapManager selectedYear={selectedYear} />
    </Fragment>
  );
};

export default MapControls;
