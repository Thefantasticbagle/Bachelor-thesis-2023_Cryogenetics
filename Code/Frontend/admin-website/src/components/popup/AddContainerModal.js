import * as React from 'react';
import Box from '@mui/material/Box';
import Typography from '@mui/material/Typography';
import Modal from '@mui/material/Modal';
import { Button, MenuItem, TextField, Grid, FormControl, InputLabel } from '@mui/material';
import fetchData from '../../globals/fetchData';

const style = {
  position: 'absolute',
  top: '50%',
  left: '50%',
  transform: 'translate(-50%, -50%)',
  width: 700,
  bgcolor: 'background.paper',
  border: '2px solid #000',
  boxShadow: 24,
  p: 4,
};


export default function AddContainerModal({ open, setOpen, onClose}) {
  const [rows, setRows] = React.useState([]);
  const [location, setLocation] = React.useState("");
  const [client, setClient] = React.useState("");
  const [containerModel, setContainerModel] = React.useState("");
  const [containerStatus, setContainerStatus] = React.useState("");
  const [serialNumber, setSerialNumber] = React.useState('');
  const [lastFilled, setLastFilled] = React.useState('');
  const [address, setAddress] = React.useState('');
  const [invoice, setInvoice] = React.useState('');
  const [tempId, setTempId] = React.useState('');
  const [comment, setComment] = React.useState('');
  const [maintenanceNeeded, setMaintenanceNeeded] = React.useState(0);
  const [productionDate, setProductionDate] = React.useState('');

   async function fetchRowData() {
    try {
      const response = await fetchData('/api/create/container', 'GET');
      setRows(response);
    } catch (error) {
      console.error(error);
    }
  }

  //Call the API when Open is true
  React.useEffect(() => { 
    if (open){
      fetchRowData();
    }
  }, [open]); 

  const handleCloseModal = () => {
    onClose();
    setOpen(false);
    setLocation("");
    setClient("");
    setContainerModel("");
    setContainerStatus("");
    setSerialNumber("");
    setLastFilled("");
    setAddress("");
    setInvoice("");
    setTempId("");
    setComment("");
    setMaintenanceNeeded(0);
    setProductionDate("");
  }

  const handleSubmit = async () => {
    try {
      const data = [{
        location_id: location,
        client_id: client || null,
        container_model_name: containerModel,
        container_status_name: containerStatus,
        container_sr_number: parseInt(serialNumber),
        last_filled: lastFilled || null,
        address: address || null,
        invoice: invoice || null,
        temp_id: parseInt(tempId) ,
        comment: comment || null,
        maintenance_needed: maintenanceNeeded,
        production_date: productionDate,
      }]; 
      console.log(data);
      await fetchData("/api/container", 'POST', data);
      handleCloseModal();
    } catch (error) {
      alert(`Error: ${error.message}`);
    }
  };

  //Retrieve all options
  const locationOptions = rows && rows.location ? rows.location.map(location => ({ value: location.location_id, label: location.location_name })) : [];
  const containerModelOptions = rows && rows.container_model ? rows.container_model.map(containerModel => ({ value: containerModel.container_model_name, label: containerModel.container_model_name })) : [];
  const containerStatusOptions = rows && rows.container_status ? rows.container_status.map(containerStatus => ({ value: containerStatus.container_status_name, label: containerStatus.container_status_name })) : [];
  const clientOptions = rows && rows.client ? rows.client.map(client => ({ value: client.client_id, label: client.client_name })) : [];


  return (
    <Modal open={open} onClose={handleCloseModal}  aria-labelledby="modal-modal-title" aria-describedby="modal-modal-description">
      
      <Box sx={style}>
        <Typography id="modal-modal-title" variant="h6" component="h2" >
          Add Container
        </Typography>

        <Grid container spacing={2}>
            <Grid item xs={12} sm={4}>
              <TextField
                fullWidth
                type={"number"}
                label="Container Serial Number"
                id="serial-number"
                value={serialNumber}
                required
                inputProps={{
                  onKeyDown: (event) => {
                    const key = event.key;
                    // Allow only numeric characters (0-9)
                    if ((key !== "Backspace" && key !== "Delete" && isNaN(key)) || key === " ") {
                      event.preventDefault();
                    }
                  }
                }}
                onChange={(event) => setSerialNumber(event.target.value)}
              />
            </Grid>

            <Grid item xs={12} sm={4}>
              <TextField
                  select
                  required
                  label="Container model"
                  id="container-model"
                  fullWidth
                  value={containerModel}
                  onChange={(event) => setContainerModel(event.target.value)}
                >
                <MenuItem value={""} disabled>Select a container model</MenuItem>
                {containerModelOptions.map(option => (
                  <MenuItem key={option.value} value={option.value}>{option.label}</MenuItem>
                ))}
              </TextField>
            </Grid>

            <Grid item xs={12} sm={4}>
              <TextField
                  select
                  required
                  label="Container status"
                  id="container-status"
                  fullWidth
                  value={containerStatus}
                  onChange={(event) => setContainerStatus(event.target.value)}
                >
                <MenuItem value={""} disabled>Select a container status</MenuItem>
                {containerStatusOptions.map(option => (
                  <MenuItem key={option.value} value={option.value}>{option.label}</MenuItem>
                ))}
              </TextField>
            </Grid>

            <Grid item xs={12} sm={4}>
              <TextField
                  select
                  required
                  label="Location"
                  id="location"
                  fullWidth
                  sx={{mt: 3}}
                  value={location}
                  onChange={(event) => setLocation(event.target.value)}
                >
                <MenuItem value={""} disabled>Select a location</MenuItem>
                {locationOptions.map(option => (
                  <MenuItem key={option.value} value={option.value}>{option.label}</MenuItem>
                ))}
              </TextField>
            </Grid>

            <Grid item xs={12} sm={4}>
              <TextField
                  select
                  label="Client"
                  id="client"
                  fullWidth
                  sx={{mt: 3}}
                  value={client}
                  onChange={(event) => setClient(event.target.value)}
                >
                <MenuItem value={""} disabled>Select a client</MenuItem>
                {clientOptions.map(option => (
                  <MenuItem key={option.value} value={option.value}>{option.label}</MenuItem>
                ))}
              </TextField>
            </Grid>

            <Grid item xs={12} sm={4}>
            <InputLabel>Last Filled <sup>*</sup></InputLabel>
              <TextField
                id="lastFilled"
                type="date"
                fullWidth
                value={lastFilled}
                onChange={(event) => setLastFilled(event.target.value)}
              />
            </Grid>

            <Grid item xs={12} sm={4}>
              <TextField
                fullWidth
                label="Address"
                id="address"
                sx={{mt: 3}}
                value={address}
                onChange={(event) => setAddress(event.target.value)}
              />
            </Grid>

            <Grid item xs={12} sm={4}>
            <InputLabel>Invoice date</InputLabel>
              <TextField
                id="invoice"
                type="date"
                fullWidth
                value={invoice}
                onChange={(event) => setInvoice(event.target.value)}
              />
            </Grid>

            <Grid item xs={12} sm={4}>
              <TextField
                fullWidth
                required
                type={"number"}
                label="Temp ID"
                id="temp-id"
                sx={{mt: 3}}
                value={tempId}
                inputProps={{
                  onKeyDown: (event) => {
                    const key = event.key;
                    // Allow only numeric characters (0-9)
                    if ((key !== "Backspace" && key !== "Delete" && isNaN(key)) || key === " ") {
                      event.preventDefault();
                    }
                  }
                }}
                onChange={(event) => setTempId(event.target.value)}
              />
            </Grid>

            <Grid item xs={12} sm={12}>
              <TextField
                fullWidth
                label="Comment"
                id="comment"
                multiline
                rows={4}
                sx={{mt: 3}}
                value={comment}
                onChange={(event) => setComment(event.target.value)}
              />
            </Grid>

            <Grid item xs={12} sm={4}>
              <FormControl fullWidth>
                <TextField
                  select
                  label="Maintenance Needed"
                  id="maintenanceNeeded"
                  fullWidth
                  sx={{mt: 3}}
                  value={maintenanceNeeded}
                  onChange={(event) => setMaintenanceNeeded(event.target.value)}
                >
                  <MenuItem value={1}>Yes</MenuItem>
                  <MenuItem value={0}>No</MenuItem>
                </TextField>
              </FormControl>
            </Grid>

            <Grid item xs={12} sm={4} >
            <InputLabel>Production Date <sup>*</sup></InputLabel>
              <TextField
                id="productionDate"
                type="date"
                fullWidth
                required
                value={productionDate}
                onChange={(event) => setProductionDate(event.target.value)}
              />
            </Grid>

          </Grid>
          
        <Button variant="contained" sx={{ m: 2 }} color="error" onClick={handleCloseModal}>Cancel</Button>

        <Button
          variant="contained"
          sx={{ m: 2 }}
          color="success"
          onClick={handleSubmit}
          disabled={!lastFilled || !serialNumber || !containerModel || !containerStatus || !tempId || !productionDate}
        >
          Confirm
        </Button>      
      </Box>
      
    </Modal>
  );
}