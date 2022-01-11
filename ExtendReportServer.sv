//-----------------------------------------------------------------------------
//Managing the UVM Report Server
//Formatting a lengthy UVM message to parts more understandable
//-----------------------------------------------------------------------------
class my_report_server extends uvm_report_server; 

    //Typically most unit TB don`t have a lot of files
    //creating a list of their short names
    local string m_filename_cache[string];

    //filename - holds the entire path of the file /<workspace>/<folder>/..../file
    //returns - just the file name
    protected function string get_last_name(filename);
        string last_name = "";

        //If filename does not exist add to cache and return else return from cache
        if(!m_filename_cache.exists(filename)) begin
            foreach(filename[i]) begin
                if(filename[i]=='/') 
                    last_name = "";
                else 
                    last_name = {last_name, filename[i]};
            end 
            m_filename_cache[filename] = last_name;
        end 
        return m_filename_cache[filename];

    endfunction : get_last_name

    //Short severity name
    protected function string short_severity_name(uvm_severity severity);
        case(severity): 
            UVM_INFO:       return "I:";
            UVM_ERROR:      return "E:";
            UVM_WARNING:    return "W:";
            UVM_FATAL:      return "Fatal:"; //Fatal is previously addressed
            default:        return "?:";
        endcase
    endfunction : short_severity_name

    //Extending the virtual function for changing messages
    virtual function string compose_message ( uvm_severity severity, 
        string name, 
        string id, 
        string message, 
        string filename, 
        int line );
    
        //Display full fatal message
        if(severity == UVM_FATAL) begin
            return $psprintf("%0s:%0t | %0s: %0d | %0s | %0s | %0s",
                severity.name,
                $time, 
                get_last_name(filename),  ̰
                line, 
                name,
                id, 
                message)
        end 

        return $psprintf("%0s:%0t | %0s: %0d | %0s | %0s | %0s",
            short_severity_name(severity),
            $time, 
            get_last_name(filename), 
            line, 
            name,
            id, 
            message)

endclass
