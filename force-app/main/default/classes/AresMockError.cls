public with sharing class AresMockError implements HttpCalloutMock{
    Integer statusCode;

    @TestVisible
    AresMockError(Integer statusCode){
        this.statusCode = statusCode;
    }

    public HttpResponse respond(HttpRequest req){
        HttpResponse res = new HttpResponse();
        res.setStatusCode(statusCode);
        res.setBody('Error');
        return res;
}
}