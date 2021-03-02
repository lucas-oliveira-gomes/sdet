package com.lucas.gomes.tests.api;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import org.hamcrest.Matchers;
import org.junit.Assert;
import org.junit.Test;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

public class RestAPITest {

	private static final String URL = "https://api.interzoid.com/getweather?city={city}&state={state}";
	private static final String URL_MISSING_PARAMS = "https://api.interzoid.com/getweather";
	private static final String X_API_KEY = "1ebc309a2923a60346aed9f420048cf0";
	

	@Test
	public void testRestRequestMustReturnHTTP_OKWhenPassingValidCombinationOfCitAndState() {
		TestRestTemplate testRestTemplate = setupRestTemplate();
		Map<String, String> params = new HashMap<>();
		params.put("city", "Round Rock");
		params.put("state", "TX");
		ResponseEntity<String> entity = testRestTemplate.getForEntity(URL, String.class, params);

		Assert.assertThat("Status Code should be 200", entity.getStatusCode().value(), Matchers.is(HttpStatus.OK.value()));
		Assert.assertThat("Status Code description should be OK", entity.getStatusCode().name(),
				Matchers.is(HttpStatus.OK.name()));

	}
	
	@Test
	public void testRestRequestMustReturnHTTP_NOT_FOUNDWhenCityAndStateDoNotFindValidMatch() {
		TestRestTemplate testRestTemplate = setupRestTemplate();
		Map<String, String> params = new HashMap<>();
		params.put("city", "Tampa");
		params.put("state", "TX");
		ResponseEntity<String> entity = testRestTemplate.getForEntity(URL, String.class, params);

		Assert.assertThat("Status Code should be 404", entity.getStatusCode().value(), Matchers.is(HttpStatus.NOT_FOUND.value()));
		Assert.assertThat("Status Code description should be NOT_FOUND", entity.getStatusCode().name(),
				Matchers.is(HttpStatus.NOT_FOUND.name()));

	}

	
	
	@Test
	public void testRestRequestMustReturnHTTP_BAD_REQUESTWhenNotInformingCitAndState() {
		TestRestTemplate testRestTemplate = setupRestTemplate();
		Map<String, String> params = new HashMap<>();
		params.put("city", "Tampa");
		params.put("state", "TX");
		ResponseEntity<String> entity = testRestTemplate.getForEntity(URL_MISSING_PARAMS, String.class, params);

		Assert.assertThat("Status Code should be 400", entity.getStatusCode().value(), Matchers.is(HttpStatus.BAD_REQUEST.value()));
		Assert.assertThat("Status Code description should be BAD_REQUEST", entity.getStatusCode().name(),
				Matchers.is(HttpStatus.BAD_REQUEST.name()));

	}
	
	private TestRestTemplate setupRestTemplate() {
		TestRestTemplate testRestTemplate = new TestRestTemplate();

		testRestTemplate.getRestTemplate().setInterceptors(Collections.singletonList((request, body, execution) -> {
			request.getHeaders().add("x-api-key", X_API_KEY);
			return execution.execute(request, body);
		}));
		return testRestTemplate;
	}
}
