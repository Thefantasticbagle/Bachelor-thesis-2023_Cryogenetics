import * as React from 'react';
import { useState } from 'react';
import PropTypes from 'prop-types';
import Box from '@mui/material/Box';
import Button from '@mui/material/Button';
import Table from '@mui/material/Table';
import TableBody from '@mui/material/TableBody';
import TableCell from '@mui/material/TableCell';
import TableContainer from '@mui/material/TableContainer';
import TableHead from '@mui/material/TableHead';
import TablePagination from '@mui/material/TablePagination';
import TableRow from '@mui/material/TableRow';
import TableSortLabel from '@mui/material/TableSortLabel';
import Toolbar from '@mui/material/Toolbar';
import Typography from '@mui/material/Typography';
import Paper from '@mui/material/Paper';
import IconButton from '@mui/material/IconButton';
import Tooltip from '@mui/material/Tooltip';
import FormControlLabel from '@mui/material/FormControlLabel';
import Switch from '@mui/material/Switch';
import FilterListIcon from '@mui/icons-material/FilterList';
import { TextField } from '@mui/material';
import { visuallyHidden } from '@mui/utils';
import EditUserModal from './popup/EditUserModal';
import AddUserModal from './popup/AddUserModal';
import './TableLayout.css';
import {stableSort , getComparator} from '../globals/globalFunctions';

function createData(User_ID, User_Name, Login_Code, Location_Name, User_IsActive) {
  return {
    User_ID, User_Name, Login_Code, Location_Name, User_IsActive
  };
}

const rows = [
  createData(1,"Håvard Bø",322,"Hamar", true),
  createData(2,"Mats Greeven",221,"Oslo", true),
  createData(3,"Lars Ruud",541,"Hamar", true),
]; 

const headCells = [
  {
    id: 'User_ID', numeric: true, disablePadding: true, label: 'User_ID',
  },
  {
    id: 'User_Name', numeric: true, disablePadding: true, label: 'User_Name',
  },
  {
    id: 'Login_Code', numeric: true, disablePadding: true, label: 'Login_Code',
  },
  {
    id: 'Location_Name', numeric: false, disablePadding: true, label: 'Location_Name',
  },
  {
    id: 'User_IsActive', numeric: true, disablePadding: true, label: 'User_IsActive', 
  },
];

function EnhancedTableHead(props) {
  const { order, orderBy, onRequestSort } =
    props;
  const createSortHandler = (property) => (event) => {
    onRequestSort(event, property);
  };

  return (
    <TableHead>
      <TableRow>
        {headCells.map((headCell) => (
          <TableCell
            key={headCell.id}
            align='center'
            padding={headCell.disablePadding ? 'none' : 'normal'}
            sortDirection={orderBy === headCell.id ? order : false}
          >
            <TableSortLabel
              active={orderBy === headCell.id}
              direction={orderBy === headCell.id ? order : 'asc'}
              onClick={createSortHandler(headCell.id)}
            >
              {headCell.label}
              {orderBy === headCell.id ? (
                <Box component="span" sx={visuallyHidden}>
                  {order === 'desc' ? 'sorted descending' : 'sorted ascending'}
                </Box>
              ) : null}
            </TableSortLabel>
          </TableCell>
        ))}
      </TableRow>
    </TableHead>
  );
}

EnhancedTableHead.propTypes = {
  onRequestSort: PropTypes.func.isRequired,
  order: PropTypes.oneOf(['asc', 'desc']).isRequired,
  orderBy: PropTypes.string.isRequired,
  rowCount: PropTypes.number.isRequired,
};

function EnhancedTableToolbar({ searchTerm, setSearchTerm }) {
  return (
    <Toolbar
      sx={{
        pl: { sm: 2 },
        pr: { xs: 1, sm: 1 },
      }}
    >
        <Typography
          sx={{ flex: '1 1 100%' }}
          variant="h6"
          id="tableTitle"
          component="div"
        >
          Users / Employees
        </Typography>

        <Tooltip title="Filter list">
          <IconButton>
            <FilterListIcon />
          </IconButton>
        </Tooltip>

        <TextField
        label="Search"
        value={searchTerm}
        onChange={(e) => setSearchTerm(e.target.value)}
        sx={{ ml: 2, width: 200 }}
      />
      
    </Toolbar>
  );
}

export default function Users() {
  const [order, setOrder] = React.useState('asc');
  const [orderBy, setOrderBy] = React.useState('User_ID');
  const [page, setPage] = React.useState(0);
  const [dense, setDense] = React.useState(false);
  const [rowsPerPage, setRowsPerPage] = React.useState(10);

  const [selectedRow, setSelectedRow] = useState(null);
  const [openModal, setOpenModal] = useState(false);

  const [searchTerm, setSearchTerm] = useState('');

  //DEFINE WHAT THE COLLUMNS ARE FILTERED IN SEARCH
  const filterRows = (row) => {
    return (
      row.User_Name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      row.Location_Name.toLowerCase().includes(searchTerm.toLowerCase())
    );
  };
  const filteredRows = rows.filter(filterRows);

  const handleOpenModal = () => {
    setOpenModal(true);
  };

  function handleRowClick(rowData) {
    setSelectedRow(rowData);
  }

  const handleRequestSort = (event, property) => {
    const isAsc = orderBy === property && order === 'asc';
    setOrder(isAsc ? 'desc' : 'asc');
    setOrderBy(property);
  };

  const handleChangePage = (event, newPage) => {
    setPage(newPage);
  };

  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(parseInt(event.target.value, 10));
    setPage(0);
  };

  const handleChangeDense = (event) => {
    setDense(event.target.checked);
  };

  // Avoid a layout jump when reaching the last page with empty rows.
  const emptyRows =
    page > 0 ? Math.max(0, (1 + page) * rowsPerPage - rows.length) : 0;

  return (
    
    <Box sx={{ width: '100%' }}>
    <div className = "grid-container">
      <div className = "grid-child table"><Paper sx={{ width: '100%', mb: 2 }}>
      <EnhancedTableToolbar searchTerm={searchTerm} setSearchTerm={setSearchTerm}/>
        <TableContainer>
          <Table
            sx={{ minWidth: 750 }}
            aria-labelledby="tableTitle"
            size={dense ? 'small' : 'medium'}
          >
            <EnhancedTableHead
              order={order}
              orderBy={orderBy}
              onRequestSort={handleRequestSort}
              rowCount={filteredRows.length}
            />
            <TableBody>
              {stableSort(filteredRows,getComparator(order, orderBy))
                .slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage)
                .map((row, index) => {
                  const labelId = `enhanced-table-checkbox-${index}`;

                  return (
                    <TableRow
                      hover
                      role="checkbox"
                      tabIndex={-1}
                      key={row.User_ID}
                    >
                      
                      <TableCell
                        component="th"
                        id={labelId}
                        scope="row"
                        padding="none"
                        align='center'
                      >
                        {"#"+row.User_ID}
                      </TableCell>
                      <TableCell align='center'>{row.User_Name}</TableCell>
                      <TableCell align='center'>{row.Login_Code}</TableCell>
                      <TableCell align='center'>{row.Location_Name}</TableCell>
                      <TableCell align="center">{row.User_IsActive ? "True" : "False"}</TableCell>
                      <TableCell onClick={() => handleRowClick(row)}> 
                        <Button variant="outlined"> Edit </Button>
                    </TableCell> 
                    </TableRow>
                  );
                })}
              {emptyRows > 0 && (
                <TableRow
                  style={{
                    height: (dense ? 33 : 53) * emptyRows,
                  }}
                >
                  <TableCell colSpan={6} />
                </TableRow>
              )}
            </TableBody>
          </Table>
          {selectedRow && ( //Checks if there is a selected Row, If this line isnt here, you will get an "Error child is empty" console message.
        <EditUserModal
          selectedRow={selectedRow}
          setSelectedRow={setSelectedRow}
        />
      )} 
        </TableContainer>
        <TablePagination
          rowsPerPageOptions={[10, 25, 50]}
          component="div"
          count={rows.length}
          rowsPerPage={rowsPerPage}
          page={page}
          onPageChange={handleChangePage}
          onRowsPerPageChange={handleChangeRowsPerPage}
        />
      </Paper>
      </div>
      <div className = "grid-child-buttons">
        <Button variant='contained' color='success' onClick={handleOpenModal}> Add user </Button>
        <AddUserModal open={openModal} setOpen={setOpenModal} />
      </div>
    </div>
      <FormControlLabel
        control={<Switch checked={dense} onChange={handleChangeDense} />}
        label="Dense padding"
        sx={{paddingLeft:"20px"}}
      />
    </Box>
  );
}