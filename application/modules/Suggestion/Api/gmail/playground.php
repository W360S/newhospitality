<?php
/* Copyright (c) 2009 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * Author: Eric Bidelman <e.bidelman@google.com>
 */
  ini_set('display_errors', TRUE);
  error_reporting(E_ALL);

require_once('common.inc.php');

function get_access_token () {

//http://code.google.com/apis/accounts/docs/AuthSub.html#AuthSubRequest
//https://www.google.com/accounts/ManageDomains
//$_REQUEST['consumer_key'] = 'devaddons.socialengineaddons.com';
$_REQUEST['consumer_key'] = 'hospitality.vn';
$_REQUEST['sig_method'] = 'HMAC-SHA1';
//$_REQUEST['consumer_secret'] = 'wQ7iSnLdy+UGUrlNUxXDU1tt';
$_REQUEST['consumer_secret']   = 'aJHej4sr3uqaxQi6/+gxp8BW';
$_REQUEST['scope'] = 'http://www.google.com/m8/feeds/'; 
$_REQUEST['host'] = 'https://www.google.com/accounts';
$_REQUEST['token_endpoint'] = 'https://www.google.com/accounts/OAuthGetRequestToken';
$_REQUEST['oauth_params_loc'] = 'header';
$_REQUEST['content-type'] = 'Content-Type: application/atom+xml';
$_REQUEST['gdata-version'] = '2.0';
$_REQUEST['tokenType'] = 'request';
$_REQUEST['http_method'] = 'GET';
$_REQUEST['feedUri'] = '';
$_REQUEST['postData'] = '';
$_REQUEST['oauth_token'] = '';

// Use consumer key/secret set when request token was fetched or setup a
// consumer based on the request params (e.g. for 2 legged OAuth)
if (isset($_SESSION['consumer_key']) && isset($_SESSION['consumer_key'])) {
  $consumer = new OAuthConsumer($_SESSION['consumer_key'],
                                $_SESSION['consumer_secret']);
} else {
  $consumer = new OAuthConsumer(@$_REQUEST['consumer_key'],
                                @$_REQUEST['consumer_secret']);
}

// OAuth v1.0a contains the oauth_verifier parameter coming back from the SP


$scope = @$_REQUEST['scope'];
$http_method = @$_REQUEST['http_method'];
$feedUri = @$_REQUEST['feedUri'];
$postData = @$_REQUEST['postData'];
$privKey = isset($_REQUEST['privKey']) && trim($_REQUEST['privKey']) != '' ? $_REQUEST['privKey'] : NULL;
$token_endpoint = @$_REQUEST['token_endpoint'];

var_dump($_SERVER['HTTP_HOST']); exit;

$callback_url = 'http://' . $_SERVER['HTTP_HOST'] . Zend_Controller_Front::getInstance()->getBaseUrl() . '/suggestion/usercontacts/getgooglecontacts';

// OAuth token from token/secret parameters
//$token = @$_REQUEST['oauth_token'];
//$token_secret = isset($_SESSION['token_secret']) ? $_SESSION['token_secret'] : @$_REQUEST['token_secret'];
//$oauth_token = $token ? new OAuthToken($token, $token_secret) : NULL;

$sig_method = new OAuthSignatureMethod_HMAC_SHA1 ();
if (!empty($_GET['oauth_verifier'])) {
  $token = $_GET['oauth_token'];
$token_secret = isset($_SESSION['oauth_token_secret']) ? $_SESSION['oauth_token_secret'] : @$_REQUEST['token_secret'];
$oauth_token = $token ? new OAuthToken($token, $token_secret) : NULL;
  $req = OAuthRequest::from_consumer_and_token($consumer, $oauth_token, 'GET',
        'https://www.google.com/accounts/OAuthGetAccessToken', array('oauth_verifier' => $_GET['oauth_verifier']));
    $req->sign_request($sig_method, $consumer, $oauth_token, $privKey);

   
 $response = send_signed_request('GET', 'https://www.google.com/accounts/OAuthGetAccessToken', array($req->to_header()));
 

   
if($_GET['oauth_verifier'] && !isset($_SESSION['oauth_verifier'])) {
  $_SESSION['oauth_verifier'] = $_GET['oauth_verifier'];
}
}
/**
 *  Main action controller
 */
switch(@$_REQUEST['tokenType']) {

  // STEP 1: Fetch request token
  case 'request':

    // Cleanup: started the process to get a new access token
    unset($_SESSION['access_token']);
    unset($_SESSION['token_secret']);
    unset($_SESSION['oauth_verifier']);
    unset($_SESSION['consumer_key']);
    unset($_SESSION['consumer_secret']);

    // Use the user's own private key if set. Defaults to the Playground's.
    if ($privKey) {
      $_SESSION['privKey'] = $privKey;
    } else {
      unset($_SESSION['privKey']);
    }

    // Use the user's own consumer key ifset. Defaults to the Playground's.
    if ($_REQUEST['consumer_key']) {
      $_SESSION['consumer_key'] = $_REQUEST['consumer_key'];
    } else {
      unset($_SESSION['consumer_key']);
    }

    // Use the user's own consumer secret if set. Defaults to the Playground's.
    if ($_REQUEST['consumer_secret']) {
      $_SESSION['consumer_secret'] = $_REQUEST['consumer_secret'];
    } else {
      unset($_SESSION['consumer_secret']);
    }

    // Handle certain Google Data scopes that have their own approval pages.
    if ($scope) {
      // Health still uses OAuth v1.0
      if (preg_match('/health/', $scope) || preg_match('/h9/', $scope)) {
        $params = array('scope' => $scope);
      } else {
        // Use the OAuth v1.0a flow (callback in the request token step)
        $params = array('scope' => $scope, 'oauth_callback' => $callback_url);
      }
      $url = $token_endpoint . '?scope=' . urlencode($scope);
    } else {
      $params = array('oauth_callback' => $callback_url);
      $url = $token_endpoint;
    }

    // Installed app use case
    $oauth_token = NULL;

    // GET https://www.google.com/accounts/OAuthGetRequestToken?scope=<SCOPEs>
    $req = OAuthRequest::from_consumer_and_token($consumer, $oauth_token, 'GET',
                                                 $url, $params);
    $req->sign_request($sig_method, $consumer, $oauth_token, $privKey);
    $response = send_signed_request('GET', $url, array($req->to_header()));
    preg_match('/oauth_token=(.*)&oauth_token_secret=(.*)/', $response, $matches);
    preg_match('/oauth_token_secret=(.*)&oauth_callback_confirmed=(.*)/', $response, $matches_temp);
    $_SESSION['oauth_token_secret'] = urldecode($matches_temp[1]);
    $auth_url = 'https://www.google.com/accounts/OAuthAuthorizeToken'. '?oauth_token=' . $matches[1];
     header('location: ' . $auth_url);
     // Fill response
    

    exit;  // ajax request, just stop exec

    break;

  // STEP 2: Authorize the request token.  Redirect user to approval page.
  case 'authorize':
    // OAuth v1.0a - no callback URL provided to the authorization page.
    $auth_url = $token_endpoint . '?oauth_token=' . $oauth_token->key;

    // Cover special cases for Google Health and YouTube approval pages
    if (preg_match('/health/', $scope) || preg_match('/h9/', $scope)) {
      // Google Health - append permission=1 parameter to read profiles
      // and callback URL for v1.0 flow.
      $auth_url .= '&permission=1&oauth_callback=' . urlencode($callback_url);
    }

    // Redirect to https://www.google.com/accounts/OAuthAuthorizeToken
    echo json_encode(array(
        'html_link' => '',
        'base_string' => '',
        'response' => "<script>window.location='$auth_url';</script>"
    ));

    exit; // ajax request, just stop exec

    break;

  // STEP 3: Upgrade authorized request token to an access token.
  case 'access_token':
    // GET https://www.google.com/accounts/OAuthGetAccessToken
    $req = OAuthRequest::from_consumer_and_token($consumer, $oauth_token, 'GET',
        $token_endpoint, array('oauth_verifier' => $_SESSION['oauth_verifier']));
    $req->sign_request($sig_method, $consumer, $oauth_token, $privKey);


    $response = send_signed_request('GET', $token_endpoint, array($req->to_header()));

    // Extract and remember oauth_token (access token) and oauth_token_secret
    preg_match('/oauth_token=(.*)&oauth_token_secret=(.*)/', $response, $matches);
    $_SESSION['access_token'] = urldecode(@$matches[1]);
    $_SESSION['token_secret'] = urldecode(@$matches[2]);

    echo json_encode(array(
        'html_link' => $req->to_url(),
        'base_string' => $req->get_signature_base_string(),
        'response' => $response,
        'authorization_header' => $req->to_header()
    ));

    exit;  // ajax request, just stop exec

    break;

  // Fetch data.  User has valid access token.
  case 'execute':
    $feedUri = trim($feedUri);

    // create an associative array from each key/value url query param pair.
    $params = array();
    $pieces = explode('?', $feedUri);
    if (isset($pieces[1])) {
     $params = explode_assoc('=', '&', $pieces[1]);
    }

    // urlencode each url parameter key/value pair
    $tempStr = $pieces[0];
    foreach ($params as $key=>$value) {
      $tempStr .= '&' . urlencode($key) . '=' . urlencode($value);
    }
    $feedUri = preg_replace('/&/', '?', $tempStr, 1);

    $req = OAuthRequest::from_consumer_and_token($consumer, $oauth_token,
                                                 $http_method, $feedUri, $params);
    $req->sign_request($sig_method, $consumer, $oauth_token, $privKey);

    $auth_header = $req->to_header();

    // decide where to put the oauth_* params (Authorization header or in URL)
    if ($_REQUEST['oauth_params_loc'] == 'query') {
      $feedUri = $req->to_url();
      $auth_header = null;
    }

    $content_type = $_POST['content-type'];
    $gdataVersion = 'GData-Version: ' . @$_REQUEST['gdata-version'];
    $result = send_signed_request($http_method, $feedUri,
                                  array($auth_header, $content_type, $gdataVersion), $postData);

    if (!$result) {
      die("{'html_link' : '" . $req->to_url() . "', " .
           "'base_string' : '" . $req->get_signature_base_string() . "', " .
           "'response' : '" . $result . "'}");  // return json
    }

    $result = split('<', $result, 2);

    // If response was not XML xml_pretty_printer() will throw exception.
    // In that case, set the response body directly from the result
    try {
      $response_body = @xml_pretty_printer(isset($result[1]) ? '<' . $result[1] : $result[0], true);
    } catch(Exception $e) {
      $response_body =  isset($result[1]) ? '<' . $result[1] : $result[0];
    }

    // <pre> tags needed for IE
    $response_body = '<pre>' . $response_body . '</pre>';

    echo json_encode(array('html_link' => $req->to_url(),
                           'base_string' =>  $req->get_signature_base_string(),
                           'headers' => isset($result[1]) ? $result[0] : '',
                           'response' => $response_body,
                           'authorization_header' => $auth_header));
    exit;

    break;

  // 'available feeds' button. Uses AuthSubTokenInfo to parse out feeds the token can access.
  case 'discovery':
    $url = 'https://www.google.com/accounts/AuthSubTokenInfo';
    $req = OAuthRequest::from_consumer_and_token($consumer, $oauth_token, 'GET',
                                                 $url);
    $req->sign_request($sig_method, $consumer, $oauth_token, $privKey);

    $response = send_signed_request('GET', $req);

    // Parse out valid scopes returned for this access token
    preg_match_all('/Scope.*=(.*)/', $response, $matches);

    echo json_encode(array(
        'html_link' => $req->to_url(),
        'base_string' => $req->get_signature_base_string(),
        'authorization_header' => $req->to_header(),
        'args' => json_encode($matches[1]),
        'callback' => 'getAvailableFeeds'
    ));

    exit;  // ajax request, just stop execution

    break;
}
}

function get_access_token_temp ($oauth_verifier, $oauth_token_secret) {
$_REQUEST['consumer_key'] = 'devaddons.socialengineaddons.com';
$_REQUEST['sig_method'] = 'HMAC-SHA1';
$_REQUEST['consumer_secret'] = 'wQ7iSnLdy+UGUrlNUxXDU1tt';
$_REQUEST['scope'] = 'http://www.google.com/m8/feeds/'; 
$_REQUEST['host'] = 'https://www.google.com/accounts';
$_REQUEST['token_endpoint'] = 'https://www.google.com/accounts/OAuthGetRequestToken';
$_REQUEST['oauth_params_loc'] = 'header';
$_REQUEST['content-type'] = 'Content-Type: application/atom+xml';
$_REQUEST['gdata-version'] = '2.0';
$_REQUEST['tokenType'] = 'request';
$_REQUEST['http_method'] = 'GET';
$_REQUEST['feedUri'] = '';
$_REQUEST['postData'] = '';
$_REQUEST['oauth_token'] = '';
$privKey = isset($_REQUEST['privKey']) && trim($_REQUEST['privKey']) != '' ? $_REQUEST['privKey'] : NULL;
$sig_method = new OAuthSignatureMethod_HMAC_SHA1 ();
$consumer = new OAuthConsumer(@$_REQUEST['consumer_key'],
                                @$_REQUEST['consumer_secret']);
	$token = $oauth_token_secret;
$token_secret = isset($_SESSION['oauth_token_secret']) ? $_SESSION['oauth_token_secret'] : @$_REQUEST['token_secret'];
$oauth_token = $token ? new OAuthToken($token, $token_secret) : NULL;
  $req = OAuthRequest::from_consumer_and_token($consumer, $oauth_token, 'GET',
        'https://www.google.com/accounts/OAuthGetAccessToken', array('oauth_verifier' => $oauth_verifier));
    $req->sign_request($sig_method, $consumer, $oauth_token, $privKey);

   
    $response = send_signed_request('GET', 'https://www.google.com/accounts/OAuthGetAccessToken', array($req->to_header()));
 preg_match('/oauth_token=(.*)&oauth_token_secret=(.*)/', $response, $matches);
 get_contacts (urldecode(@$matches[1]), urldecode(@$matches[2]));
   //return urldecode(@$matches[1]);
    //$_SESSION['access_token'] = urldecode(@$matches[1]);
    //$_SESSION['token_secret'] = urldecode(@$matches[2]);
 
}


function get_contacts ($oauth_token, $oauth_token_secret) {


 
$_REQUEST['consumer_key'] = 'devaddons.socialengineaddons.com';
$_REQUEST['sig_method'] = 'HMAC-SHA1';
$_REQUEST['consumer_secret'] = 'wQ7iSnLdy+UGUrlNUxXDU1tt';
$_REQUEST['scope'] = 'http://www.google.com/m8/feeds/'; 
$_REQUEST['host'] = 'https://www.google.com/accounts';
$_REQUEST['token_endpoint'] = 'https://www.google.com/accounts/OAuthGetRequestToken';
$_REQUEST['oauth_params_loc'] = 'header';
$_REQUEST['content-type'] = 'Content-Type: application/atom+xml';
$_REQUEST['gdata-version'] = '2.0';
$_REQUEST['tokenType'] = 'request';
$_REQUEST['http_method'] = 'GET';
$_REQUEST['feedUri'] = '';
$_REQUEST['postData'] = '';
$_REQUEST['oauth_token'] = '';
$privKey = isset($_REQUEST['privKey']) && trim($_REQUEST['privKey']) != '' ? $_REQUEST['privKey'] : NULL;
$sig_method = new OAuthSignatureMethod_HMAC_SHA1 ();
$consumer = new OAuthConsumer(@$_REQUEST['consumer_key'],
                                @$_REQUEST['consumer_secret']);
	$token = $oauth_token;
$token_secret = $oauth_token_secret;
$oauth_token = $token ? new OAuthToken($token, $token_secret) : NULL;


  $feedUri = 'http://www.google.com/m8/feeds/contacts/default/full';
  $params = array(
      
  );
  $req = OAuthRequest::from_consumer_and_token($consumer, $oauth_token,
                                               'GET', $feedUri, $params);
  $req->sign_request($sig_method, $consumer, $oauth_token);

  // Note: the Authorization header changes with each request
  $httpClient = new Zend_Gdata_HttpClient();
  $httpClient->setHeaders($req->to_header());
  $GoogleContactsClient   =   Zend_Gdata_AuthSub::getHttpClient($token, $httpClient);
 //print_r($GoogleContactsClient);die;
  
  $docsService = new Zend_Gdata($GoogleContactsClient);
 // print_r($docsService);die;
  //$query          = new Zend_Gdata_Query('http://www.google.com/m8/feeds/contacts/default/full');
  print_r($docsService->getFeed($feedUri));die;
  //$query->setMaxResults(10000);
  $feed           = $docsService->retrieveAllEntriesForFeed($docsService->getFeed($query));
  	print_r($feed);die;
	// $query = $feedUri . '?' . implode_assoc('=', '&', $params);
  $feed = $docsService->getDocumentListFeed($query);

	//$feed           = $docsService->retrieveAllEntriesForFeed($docsService->getFeed($query));
	print_r($feed);die;

  /*$req = OAuthRequest::from_consumer_and_token($consumer, $oauth_token, 'GET',
        'http://www.google.com/m8/feeds/contacts/mangal.dinesh%40gmail.com/full', array('' => urlencode("max-results=500")));
    //print_r($req);die;    
    $req->sign_request($sig_method, $consumer, $oauth_token, $privKey);*/
    $query = urlencode($feedUri . '?max-results=1000');
//$query = $feedUri . '?' . implode_assoc('=', '&', $params);
  $feed = $docsService->getDocumentListFeed($query);
  print_r($feed);die;
   
    $response = send_signed_request('GET', 'http://www.google.com/m8/feeds/contacts/mangal.dinesh%40gmail.com/full', array($req->to_header()));
    print_r($response);die;

}
?>
