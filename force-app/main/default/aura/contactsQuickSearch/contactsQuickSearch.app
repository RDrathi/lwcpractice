<aura:application>
  <link href="/resource/bootstrap/" rel="stylesheet" />
  <div class="navbar navbar-brand" role="navigation">
    <div class="container">
      <div class="modal-header">
        <a href="#" class="navbar-brand">Lightning Contacts</a>
      </div>
    </div>
    <div class="row">
      <div class="container">
        <div class="card-header">
          <div class="col-sm-12">
            <c:searchBar></c:searchBar>
            <c:contactList></c:contactList>
          </div>
          <div class="col-sm-8">
            <c:contactDetails></c:contactDetails>
          </div>
        </div>
      </div>
    </div>
  </div>
</aura:application>
