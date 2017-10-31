<?php           
    function getUsuarios()
    {
     error_reporting(-1);               
        $conn = pg_connect("host=localhost port=5432 dbname=Agrorepuestos001 user=postgres password=nathyyjulio") or 
                die(json_encode("{}"));      
        $result = pg_query ($conn,"select cedula, nombre, apellido1, apellido2 from empleados;") 
                or die(json_encode("{}"));         
        echo (json_encode( pg_fetch_all($result), JSON_UNESCAPED_UNICODE));      
    }  
    
    function deleteUsuarios()    
    {
        $cedula =  $_REQUEST.['ced'];
        error_reporting(-1);               
        $conn = pg_connect("host=localhost port=5432 dbname=Agrorepuestos001 user=postgres password=nathyyjulio") or 
                die(json_encode("{}"));         
        $result = pg_query ($conn,"delete from empleados where empleados.cedula =$cedula;") or 
                die(json_encode("{}"));      
        if($result)
        {
            echo (json_encode( pg_fetch_all($result), JSON_UNESCAPED_UNICODE));
        }
        else
        {
            die(json_encode("{}"));      
        }        
    }    
    $nombrefuncion = $_REQUEST['NF'];    
    if($nombrefuncion==="empleados")
    {
        getUsuarios();
    }   
    elseif ($nombrefuncion === "borrarEmpleado")
    {                
        deleteUsuario();
    }
?>;     
