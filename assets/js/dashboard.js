import $ from 'jquery';
import UIkit from 'uikit';
import Chart from 'chart.js';
import Chartkick from 'chartkick';
import randomColor from 'randomcolor';

function totalAmount(chartData) {
  const total = Object.keys(chartData).reduce((acc, key) => (acc + chartData[key]), 0);
  return Math.round(total);
}

function formatMoney(amount) {
  return amount.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,');
}

function generateColors(hues, chartData) {
  const colors = hues.map(hue =>
    randomColor({
      luminosity: 'bright',
      hue,
      count: Math.ceil(Object.keys(chartData).length / hues.length),
    })
  );

  return [].concat.apply([], colors);
}

// global chartkick / charts.js settings
Chartkick.options = {
  library: {
    animation: {
      easing: 'easeInOutQuad'
    }
  },
}

const chartDataElement = document.getElementById('chart-data');
const chartData = JSON.parse(chartDataElement.dataset.expensesByTag);
const expensesByTag = document.getElementById('expenses-by-tag');
const total = totalAmount(chartData);
const colors = generateColors([
  '#FF3780',
  '#A3D8D9',
  '#CBEC16',
  '#FF8989',
], chartData);

const expensesByTagChart = new Chartkick.PieChart(expensesByTag, chartData, {
  legend: false,
  colors,
  library: {
    cutoutPercentage: 60,
    elements: {
        arc: {
            borderWidth: 0
        }
    }
  },
});

$('#expenses-by-tag').append(`<div class="total-amount">${formatMoney(total)}<br />EUR</div>`);

UIkit.util.on('#offcanvas-tags', 'hide', function () {
  const selectedTags = $('.tags-filter-list input[type="checkbox"]:checked')
    .map(function () { return $(this).data('tag') })
    .toArray();


  function filterByKeys(obj, allowedKeys) {
    return Object.keys(obj)
      .filter(key => allowedKeys.includes(key))
      .reduce((o, key) => {
        o[key] = obj[key];
        return o;
      }, {});
  }

  const updatedData = filterByKeys(chartData, selectedTags);

  expensesByTagChart.updateData(updatedData);
  $('.total-amount').html(`${formatMoney(totalAmount(updatedData))}<br />EUR`);
});
