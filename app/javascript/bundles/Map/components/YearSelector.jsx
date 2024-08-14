import React, { useEffect, useState } from 'react';

const YearSelector = ({ selectedYear = 2014, selectedYearChanger }) => {
    const years = [2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023];

    return (
        <ul className="text-2xl flex flex-wrap items-center justify-center font-normal">
            {years.map((year) => (
                <li key={year} className="list-none">
                    <a className={`${year === selectedYear ? 'text-gray-800' : 'text-gray-400'} no-underline px-2`} href ="#" onClick={(e) => {
                        e.preventDefault();
                        selectedYearChanger(year);
                    }}>
                        {year}
                    </a>
                </li>
            ))}
        </ul>
    );
};

export default YearSelector;
