import Chart from 'chart.js';
import Chartkick from 'chartkick';

// global chartkick / charts.js settings
Chartkick.options = {
  library: {
    animation: {
      easing: 'easeInOutQuad'
    }
  },
}

const chartDataElement = document.getElementById('chart-data');
console.log(chartDataElement.dataset.expensesByTag);
const chartData = JSON.parse(chartDataElement.dataset.expensesByTag)
const expensesByTag = document.getElementById('expenses-by-tag')

new Chartkick.PieChart(expensesByTag, chartData, { donut: true });
