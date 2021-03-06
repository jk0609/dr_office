class Doctor
  attr_accessor(:id, :name, :spec)
  define_method(:initialize) do |attrib|
    @id = attrib[:id]
    @name = attrib[:name]
    @spec = attrib[:spec]
  end

  define_method(:==) do |dr2|
    self.id == dr2.id
  end

  define_singleton_method(:all) do
    all_doctors = []
    returned_doctors = DB.exec('SELECT * FROM doctors')
    returned_doctors.each() do |doctor|
      id = doctor["id"].to_i
      name = doctor["name"]
      spec = doctor["specialty"]
      dr_rm = Doctor.new({:id=>id,:name=>name,:spec=>spec})
      all_doctors.push(dr_rm)
    end
    all_doctors
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO doctors (name, specialty) VALUES ('#{@name}','#{@spec}') RETURNING id;")
    @id = result.first.fetch('id').to_i
  end

  define_singleton_method(:find) do |id|
    found = nil
    Doctor.all.each() do |doctor|
      if doctor.id == id
        found = doctor
      end
    end
    found
  end

  define_method(:patients) do
    my_patients = []
    # patients = DB.exec("SELECT * FROM patients WHERE doctor_id = #{self.id};")
    # patients.each() do |patient|
    #   name = patient['name']
    #   birth = patient['birth_date']
    #   dr_id = patient['doctor_id']
    #   my_patients.push(Patient.new({:name=>name, :birth=>birth, :dr_id=>dr_id}))
    # end
    Patient.all.each() do |patient|
      if patient.dr_id==self.id
        puts(patient)
        my_patients.push(patient)
      end
    end
    my_patients
  end

  define_singleton_method(:specs) do |spec|
    spec_doctors = []
    Doctor.all.each() do |doc|
      if doc.spec == spec
        spec_doctors.push(doc)
      end
    end
    spec_doctors
  end
end
