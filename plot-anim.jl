### A Pluto.jl notebook ###
# v0.14.5

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 715e1ede-b5d4-11eb-3271-136c85c6bb70
using Plots, PlutoUI

# ╔═╡ daae9b6e-bdcc-4dad-95e3-e560ae6b538e
md"""
# Plot Animation with Pluto
"""

# ╔═╡ 35716a19-6a41-41ab-9a70-5dcf6ca0b860
md"""
A: $(@bind A Slider(1:0.1:10, default=3, show_value=true))
B: $(@bind B Slider(1:0.1:10, default=3, show_value=true))
"""

# ╔═╡ c366ad57-8a39-44fa-9fbf-83b900a98ea1
begin
	n = 200
	t = LinRange(0,2π,n)
end;

# ╔═╡ 596f3f98-e563-436e-a73b-cbed476b1edb
@bind i Clock()

# ╔═╡ 1ba6b90f-677f-4818-beb5-09f26058800c
let 
	p1 = plot(A*sin.(t),A*cos.(t),xlims=(-5,5),ylims=(-10,10),label="")
	scatter!(p1,[A*cos(-i/50)],[A*sin(-i/50)],label="")
	p2 = plot(t, t->A*sin(B*t-i/50),ylims=(-10,10),label="")
	scatter!(p2,[0],[A*sin(-i/50)],label="")
	plot(p1,p2,layout=grid(1,2,widths=(0.35,0.65)))
end

# ╔═╡ Cell order:
# ╟─daae9b6e-bdcc-4dad-95e3-e560ae6b538e
# ╟─715e1ede-b5d4-11eb-3271-136c85c6bb70
# ╟─35716a19-6a41-41ab-9a70-5dcf6ca0b860
# ╟─c366ad57-8a39-44fa-9fbf-83b900a98ea1
# ╟─596f3f98-e563-436e-a73b-cbed476b1edb
# ╠═1ba6b90f-677f-4818-beb5-09f26058800c
