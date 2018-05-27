-- From: https://gist.github.com/duckfly-tw/7c3c453012906321cb00d63b12ba0711
--EXIF reader
--by Black Duck (H.L. Chin) 2016.10.21 @Kaohsiung, Taiwan
--FB: flashairtest
--reference: https://www.media.mit.edu/pia/Research/deepview/exif.html

local bitLib = require( "plugin.bit" )

local exif = {}
function exif.read(_file)

    local f = io.open(_file, "rb")
    local data = {}

    f:seek("set", 4)
    local bytes = f:read(2)
    --io.write(string.format("%02X%02X", string.byte(bytes, 1), string.byte(bytes, 2)))
    local datasize = tonumber(string.format("%02X%02X", string.byte(bytes, 1), string.byte(bytes, 2)), 16) - 2
    f:seek("cur", 7)
    bytes = f:read(1)
    -- local BE = string.format("%02X", string.byte(bytes)) == "4D"
    f:seek("cur", 6)
    bytes = f:read(2)

    -- you can't rely on BE to judge Big-endian, because jpeg only use Little-endian (Motorola)
    -- local entrysize = 0
    -- if BE then
    --  entrysize = tonumber(string.format("%02X%02X", string.byte(bytes, 2), string.byte(bytes, 1)), 16)
    -- else
    --  entrysize = tonumber(string.format("%02X%02X", string.byte(bytes, 1), string.byte(bytes, 2)), 16)
    -- end
    local entrysize = tonumber(string.format("%02X%02X", string.byte(bytes, 2), string.byte(bytes, 1)), 16)
    -- io.write(entrysize)
    local sub_ifd_offset = 0;

    while entrysize > 0 do
        local entry_tag = f:read(2)
        local entry_size = f:read(2)
        local entry_type = f:read(4)
        local entry_data_or_offset = f:read(4)
        --ofsset is from 49 49 2A 00...(12 bytes shift)

        -- we only find tag 0x8769, which means Exif SubIFD offset
        -- if string.format("%02X%02X", string.byte(entry_tag, 2), string.byte(entry_tag, 1)) == "8769" then
        if string.byte(entry_tag, 1) == 105 and string.byte(entry_tag, 2) == 135 then
            -- io.write(string.format("%02X%02X%02X%02X", string.byte(entry_data_or_offset, 4), string.byte(entry_data_or_offset, 3), string.byte(entry_data_or_offset, 2), string.byte(entry_data_or_offset, 1)))
            sub_ifd_offset = 12 + tonumber(string.format("%02X%02X%02X%02X", string.byte(entry_data_or_offset, 4), string.byte(entry_data_or_offset, 3), string.byte(entry_data_or_offset, 2), string.byte(entry_data_or_offset, 1)), 16)
            entry_tag, entry_size, entry_type, entry_data_or_offset = nil
            break
        end

        entrysize = entrysize - 1;
        entry_tag, entry_size, entry_type, entry_data_or_offset = nil
    end

    if not (sub_ifd_offset == 0) then
        f:seek("set", sub_ifd_offset)
        bytes = f:read(2)
        -- entrysize = tonumber(string.format("%02X%02X", string.byte(bytes, 2), string.byte(bytes, 1)), 16)
        entrysize = string.byte(bytes, 2)*256 + string.byte(bytes, 1)
        local now_offset = 0;

        while entrysize > 0 do
            local entry_tag = f:read(2)
            local entry_size = f:read(2)
            local entry_type = f:read(4)
            local entry_data_or_offset = f:read(4)
            --ofsset is from 49 49 2A 00...(12 bytes shift)

            -- io.write("tag:", string.format("%02X%02X", string.byte(entry_tag, 2), string.byte(entry_tag, 1)), "\n")

            -- ISO
            if ( tonumber("8827",16) == (string.byte(entry_tag, 2)*256 + string.byte(entry_tag, 1)) ) then
                -- io.write("ISO:", string.byte(entry_data_or_offset, 1) + string.byte(entry_data_or_offset, 2)*256, "\n")
                data["iso"] = string.byte(entry_data_or_offset, 1) + string.byte(entry_data_or_offset, 2)*256
            -- ExposureTime,  2 signed/unsigned long integer, value = a/b
            elseif ( tonumber("829A",16) == (string.byte(entry_tag, 2)*256 + string.byte(entry_tag, 1)) ) then 
                now_offset = f:seek()
                f:seek("set", 12 + string.byte(entry_data_or_offset, 4)*256^3 + string.byte(entry_data_or_offset, 3)*256^2 + string.byte(entry_data_or_offset, 2)*256 + string.byte(entry_data_or_offset, 1))
                bytes = f:read(4)
                local numerator = string.byte(bytes, 4)*256^3 + string.byte(bytes, 3)*256^2 + string.byte(bytes, 2)*256 + string.byte(bytes, 1)
                bytes = f:read(4)
                local denominator = string.byte(bytes, 4)*256^3 + string.byte(bytes, 3)*256^2 + string.byte(bytes, 2)*256 + string.byte(bytes, 1)
                -- io.write("exposure numerator:", string.format("%d", numerator).."/"..string.format("%d", denominator), "\n")
                f:seek("set", now_offset)
                data["exposure"] = string.format("%d", numerator).."/"..string.format("%d", denominator)
            -- Apeture
            elseif ( tonumber("829D",16) == (string.byte(entry_tag, 2)*256 + string.byte(entry_tag, 1)) ) then -- 0x829a ExposureTime,  2 signed/unsigned long integer, value = a/b
                now_offset = f:seek()
                f:seek("set", 12 + string.byte(entry_data_or_offset, 4)*256^3 + string.byte(entry_data_or_offset, 3)*256^2 + string.byte(entry_data_or_offset, 2)*256 + string.byte(entry_data_or_offset, 1))
                bytes = f:read(4)
                local numerator = string.byte(bytes, 4)*256^3 + string.byte(bytes, 3)*256^2 + string.byte(bytes, 2)*256 + string.byte(bytes, 1)
                bytes = f:read(4)
                local denominator = string.byte(bytes, 4)*256^3 + string.byte(bytes, 3)*256^2 + string.byte(bytes, 2)*256 + string.byte(bytes, 1)
                -- io.write("Apeture:", numerator/denominator, "\n")
                f:seek("set", now_offset)
                data["apeture"] = numerator/denominator
            -- EV
            elseif ( tonumber("9204",16) == (string.byte(entry_tag, 2)*256 + string.byte(entry_tag, 1)) ) then
                now_offset = f:seek()
                f:seek("set", 12 + string.byte(entry_data_or_offset, 4)*256^3 + string.byte(entry_data_or_offset, 3)*256^2 + string.byte(entry_data_or_offset, 2)*256 + string.byte(entry_data_or_offset, 1))
                bytes = f:read(4)
                local numerator = tonumber(string.format("%02X%02X%02X%02X", string.byte(bytes, 4), string.byte(bytes, 3), string.byte(bytes, 2), string.byte(bytes, 1)), 16)
                if ( bitLib.band(string.byte(bytes, 4), 0x80) == 0x80 ) then
                    numerator = (0-bitLib.band(bitLib.bnot(numerator-1), 0x7FFFFFFF))
                end
                bytes = f:read(4)
                local denominator = tonumber(string.format("%02X%02X%02X%02X", string.byte(bytes, 4), string.byte(bytes, 3), string.byte(bytes, 2), string.byte(bytes, 1)), 16)
                if ( bitLib.band(string.byte(bytes, 4), 0x80) == 0x80 ) then
                    denominator = (0-bitLib.band(bitLib.bnot(denominator-1), 0x7FFFFFFF))
                end
                -- io.write("EV numerator:", numerator/denominator, "\n")
                f:seek("set", now_offset)
                data["ev"] = numerator/denominator
            end

            entrysize = entrysize - 1;
            entry_tag, entry_size, entry_type, entry_data_or_offset = nil
        end

    end

    io.close(f)
    return data

end
--[[
--main scope
io.write("go exif!".."\n")
data = readEXIF(args[1])
io.write(data["iso"].."\n")
io.write(data["ev"].."\n")
io.write(data["apeture"].."\n")
io.write(data["exposure"].."\n")
--]]

return exif