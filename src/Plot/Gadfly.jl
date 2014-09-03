## Plotting


export plot
export complexplot,contour


## Vector routines
function plot(xx::Vector,yy::Vector;axis=-1)
    require("Gadfly")
    if axis==-1
        Main.Gadfly.plot(x=xx, y=yy, Main.Gadfly.Geom.path)
    elseif length(axis)==2
        Main.Gadfly.plot(x=xx, y=yy, Main.Gadfly.Geom.path, Main.Gadfly.Scale.y_continuous(minvalue=axis[1],maxvalue=axis[2]))
    else #length(axis)==4
        Main.Gadfly.plot(x=xx, y=yy, Main.Gadfly.Geom.path, Main.Gadfly.Scale.x_continuous(minvalue=axis[1],maxvalue=axis[2]),Main.Gadfly.Scale.y_continuous(minvalue=axis[3],maxvalue=axis[4]))    
    end    
end



function plot{T<:Real}(x::Vector{T},y::Vector{Complex{Float64}};axis=-1)
    require("Gadfly")
    require("DataFrames")    
    r=real(y)
    i=imag(y)
    if axis==-1
        Main.Gadfly.plot(Main.DataFrames.DataFrame({[x,x],[r,i],[fill("Re",length(x)),fill("Im",length(x))]},Main.DataFrames.Index([:x=>1,:y=>2,:Function=>3],[:x,:y,:Function])),
        x="x",y="y",color="Function",Main.Gadfly.Geom.path)
    else
        Main.Gadfly.plot(Main.DataFrames.DataFrame({[x,x],[r,i],[fill("Re",length(x)),fill("Im",length(x))]},Main.DataFrames.Index([:x=>1,:y=>2,:Function=>3],[:x,:y,:Function])),
        x="x",y="y",color="Function",Main.Gadfly.Geom.path, Main.Gadfly.Scale.y_continuous(minvalue=axis[1],maxvalue=axis[2]))      
    end
end

function contour(x::Vector,y::Vector,z::Matrix;levels=-1)
    require("Gadfly")
    if levels==-1
        Main.Gadfly.plot(x=x,y=y,z=z,Main.Gadfly.Geom.contour)
    else
        Main.Gadfly.plot(x=x,y=y,z=z,Main.Gadfly.Geom.contour(levels=levels))
    end
end


## Fun routines


function plot{T<:Real}(f::IFun{T};opts...)
    f=pad(f,3length(f)+50)
    plot(points(f),values(f);opts...)
end

function plot{T<:Complex}(f::IFun{T};opts...)
    f=pad(f,3length(f)+50)
    plot(points(f),values(f);opts...)
end


function plot(r::Range,f::IFun{Float64};opts...)
    plot(r,f[[r]];opts...)
end

contour(f::MultivariateFun;opts...)=contour(points(f,1),points(f,2),values(f);opts...)


function complexplot(f::IFun{Complex{Float64}};opts...) 
    f=pad(f,3length(f)+50)
    vals =values(f)

    plot(real(vals),imag(vals);opts...)
end

