var app = angular.module('toplookhubApp', ['ui.bootstrap']);

app.factory('toplookhubHomePageService', function ($http) {
	return {
		
		getTopPoliticsNews: function (count, skip) {
			return $http.get('/api/news/topnews?c=Politics&n=' + count + '&s=' + skip).then(function (result) {
				return result.data.articles;
			});
		},
		

	};
});
app.controller('ToplookhubHome', function ($scope, toplookhubHomePageService) {
	//the clean and simple way
	$scope.currentYear = (new Date).getFullYear();	
	$scope.topPoliticsNews = toplookhubHomePageService.getTopPoliticsNews(5,15);

	// Non Featured Videos i.e all Videos
	$scope.newsPerPage = 10;

	// Get all Video's Count
	// $scope.newsCount = toplookhubHomePageService.getNewsCount();
	$scope.newsCount = 150;

	// Generate the numberOfPages and pages content based on the videoCount
	$scope.$watch('newsCount', function (newsCount) {
		if (newsCount !== undefined) {
			// Sample Output: {"rows":[{"key":null,"value":650}]}
			$scope.numberOfPages = (Math.ceil(newsCount/$scope.newsPerPage)).toString();

			// Pagination plugin
			$scope.bigTotalItems = newsCount;
		}
	});

	// Javascript Custom Function to get teh URL params, decode them
	function getURLParameter (name) {
		return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search)||[,""])[1].replace(/\+/g, '%20'))||null;
	}

	// Get noneFeaturedVideos list based on the page(number) we are hitting from.
	$scope.currentPageNumber = parseInt(getURLParameter('p'), 10);
	
	if (isNaN($scope.currentPageNumber)) {
		skipValue = 0;
		$scope.currentPageNumber = 1;
	} else {
		skipValue = parseInt(($scope.currentPageNumber - 1) * $scope.videosPerPage, 10);
	}

	// Pagination plugin
	$scope.bigCurrentPage = $scope.currentPageNumber;
	$scope.maxSize = 6; // Max number of pages to be displayed at a time


	// Pagination plugin
	// This function is triggred when user tends to change the page using the plugin.
	$scope.pageChanged = function (page) {
		location.replace('/morepoliticsnews?p=' + page);
	};

	
});

