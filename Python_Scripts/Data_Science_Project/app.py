import streamlit as st
import pandas as pd
import numpy as np
import plotly.express as px
from PIL import Image
import warnings
import datetime
warnings.filterwarnings('ignore')


# Set page configuration
st.set_page_config(
    page_title='Livlina Logistics Company',
    page_icon="🚚",
    layout='wide',
    initial_sidebar_state='expanded'
)

header_left, header_mid, header_right = st.columns([1, 6, 1])

# Header in the middle with logo
with header_mid:
    st.markdown(
        f'<style> .block-container{{padding-top: 1rem;}}</style>', unsafe_allow_html=True)
    image = Image.open("C:/Users/harve/Downloads/livlina_logistics_cover.jpeg")
    st.image(image, use_column_width=False)
    # st.title("Livlina Logistics Company")
    st.markdown('</p>', unsafe_allow_html=True)


# Load dataset
insert = st.file_uploader(":file_folder: Upload a file",
                          type=(["csv", "txt", "xlsx", "xls"]))
if insert is not None:
    filename = insert.name
    st.write(filename)
    data = pd.read_csv(filename)
else:
    # inbound_data = pd.read_csv("inbound_data.csv")
    outbound_data = pd.read_csv("outbound_data.csv")
    outbound_data["Number_of_workers"] = round(
        outbound_data['Time(hrs)']/7.33333)
    outbound_data['Order_date'] = pd.to_datetime(
        outbound_data['Order_date'], format='%d-%m-%Y').dt.strftime('%Y-%m-%d')

# Set default values
view = "Overview"
zone = "Outbound"

# Home button
if st.sidebar.button("Home"):
    # Redirect to the main page or set the view variable accordingly
    view = "Overview"
    zone = "Outbound"
    st.write('<p style="font-weight:bold; font-size:24px; text-align:center;">Welcome, please select a zone you wish to explore and predict.</p>', unsafe_allow_html=True)


# Sidebar for zone selection
zone = st.sidebar.selectbox("Zone", ["Inbound", "Outbound"], index=1)

# Navigation menu for different views
view = st.sidebar.selectbox(
    "View", ["Overview", "Exploratory", "Prediction"], index=0)


def load_data(zone):
    if zone == "Outbound":
        # return inbound_data
        # elif zone == "Outbound":
        return outbound_data
    else:
        return None


# Load data based on zone selection
selected_data = load_data(zone)

col1, col2 = st.columns((2))

# Assuming you have a selected_data variable
if selected_data is not None:
    # Check if "Order_date" column exists in selected_data
    if "Order_date" in selected_data.columns:
        selected_data['Order_date'] = pd.to_datetime(
            selected_data['Order_date'])
        start_date = selected_data['Order_date'].min()
        end_date = selected_data['Order_date'].max()

        with col1:
            date1 = pd.to_datetime(st.date_input("Start Date", start_date))

        with col2:
            # st.markdown('<p style="font-weight:bold;">End Date</p>',
            #             unsafe_allow_html=True)
            date2 = pd.to_datetime(st.date_input("End Date", end_date))

        selected_data = selected_data[
            (selected_data["Order_date"] >= date1) & (selected_data["Order_date"] <= date2)].copy()
    else:
        st.warning("Selected data does not have the 'Order_date' column.")
else:
    st.warning("No data selected.")


# Function to generate exploratory plots


def generate_exploratory_plots(data, time_interval):
    with st.container():
        # st.write(f"### {time_interval} View")

        # metric_columns = st.columns(2)

        # Metric 1: Average Number of Pallets
        if time_interval == "Daily":
            selected_data_sorted = data.sort_values(
                by=['Day', 'Time(hrs)'])
            st.write(
                f"### Distribution of Workload by {time_interval} View")
            fig = px.line(selected_data_sorted, x='Day', y='Time(hrs)',
                          title='')
            fig = px.line(selected_data_sorted, x='Day', y='Nb_of_colli',
                          title='')

        elif time_interval == "Weekly":
            st.write(
                f"### Distribution of Workload by {time_interval} View")
            fig = px.line(selected_data_sorted, x='Week', y='Time(hrs)',
                          title='')
        elif time_interval == "Monthly":
            st.write(
                f"### Distribution of Workload by {time_interval} View")
            fig = px.line(selected_data_sorted, x='Month', y='Time(hrs)',
                          title='')

        st.plotly_chart(fig)


# Function to generate prediction page content


def generate_predictions(data):
    # Here, you should use your trained model to generate predictions based on the data
    # Replace with your actual predictions
    predicted_workload = np.random.rand(len(data)) * 10
    return predicted_workload


def generate_prediction_page(data):
    st.write("### Prediction View")

    # Generate predictions
    predicted_workload = generate_predictions(data)

    # Plot the predicted workload over time
    fig = px.line(x=data['Order_date'], y=predicted_workload,
                  title='Predicted Workload over Time')
    st.plotly_chart(fig)

    # Add any additional information or insights about the predictions
    st.write("Additional insights about the predictions:")
    # ...


# Create columns for header
header_left, header_mid, header_right = st.columns([1, 6, 1])


# Overview View
if view == "Overview":
    with st.container():

        if selected_data is not None:
            st.write("### Overview of the selected Zone")

            # First Row: Metric Cards
            metric_columns = st.columns(4)

            # Metric 1: Average Number of Pallets
            with metric_columns[0]:
                avg_pallets = round(selected_data['Total_Nb_Pallet'].mean())
                # st.metric("Avg Pallets", avg_pallets)
                st.markdown(
                    f'<div style="background-color: #FFD700; padding: 20px; border-radius: 10px; text-align: center;">'
                    f'<h3 style="color: #000080;">Avg Pallets</h3>'
                    f'<p style="font-size: 24px;">{avg_pallets:.2f}</p>'
                    f'</div>',
                    unsafe_allow_html=True
                )

            # Metric 2: Average Number of Colli
            with metric_columns[1]:
                avg_colli = round(selected_data['Nb_of_colli'].mean())
                # st.metric("Avg Colli", avg_colli)
                st.markdown(
                    f'<div style="background-color: #800080; padding: 20px; border-radius: 10px; text-align: center;">'
                    f'<h3 style="color: #FFFFFF;">Avg Colli</h3>'
                    f'<p style="font-size: 24px; color: #FFFFFF;">{avg_colli:.2f}</p>'
                    f'</div>',
                    unsafe_allow_html=True
                )

            # Metric 3: Average Time(hr)
            with metric_columns[2]:
                avg_time = round(selected_data['Time(hrs)'].mean(), 2)
                # st.metric("Avg Workload(hr)", avg_time)
                st.markdown(
                    f'<div style="background-color: #00FA9A; padding: 20px; border-radius: 10px; text-align: center;">'
                    f'<h3 style="color: #000080;">Workload(hr)</h3>'
                    f'<p style="font-size: 24px;">{avg_time:.2f}</p>'
                    f'</div>',
                    unsafe_allow_html=True
                )

            # Metric 4: Average Number of Workers
            with metric_columns[3]:
                avg_wrk = round(selected_data["Number_of_workers"].mean())

                st.markdown(
                    f'<div style="background-color: #FFD700; padding: 20px; border-radius: 10px; text-align: center;">'
                    f'<h3 style="color: #2f4f4f;">Avg Manpower</h3>'
                    f'<p style="font-size: 24px; color: #000080;">{avg_wrk:.2f}</p>'
                    f'</div>',
                    unsafe_allow_html=True
                )

            # Add spacing
            st.markdown("<br><br>", unsafe_allow_html=True)

            metric_columns = st.columns(2)

            # Plot of Workload by Order_dates
            with metric_columns[0]:
                st.write("### Selected View")
                selected_data_sorted = selected_data.sort_values(
                    by='Order_date')
                fig = px.line(selected_data_sorted, x='Order_date', y='Time(hrs)',
                              title='Distribution of Workload over Time')
                st.plotly_chart(fig)

            # Plot of Order frequency
            with metric_columns[1]:
                st.write("### Order Frequency")
                # st.subheader("Bar Plot for Order Frequency")
                order_frequency_bar = px.bar(
                    selected_data, x='Order_frequency', title='Bar Plot for Order Frequency')
                st.plotly_chart(order_frequency_bar)

            metric_columns = st.columns(2)

            with st.expander("View Data of TimeSeries:"):
                st.write(
                    selected_data_sorted.T.style.background_gradient(cmap="Blues"))
                csv = selected_data_sorted.to_csv(index=False).encode("utf-8")
                st.download_button("Download Data", data=csv,
                                   file_name="Timeseries.csv", mime='text/csv')

            metric_columns = st.columns(2)

            with metric_columns[0]:
                st.write("### Order Distribution")
                fig = px.pie(selected_data_sorted, values="Number_of_orders",
                             names="Order_frequency", hole=0.5)
                fig.update_traces(
                    text=selected_data_sorted["Order_frequency"], textposition="outside")
                st.plotly_chart(fig, use_container_width=True)

            with metric_columns[1]:
                st.write("### Subset of the Data")
                st.write(selected_data_sorted.style.background_gradient(
                    cmap="rainbow"))
                csv = selected_data_sorted.to_csv(index=False).encode('utf-8')
                st.download_button("Download Data", data=csv, file_name="Overview.csv", mime="text/csv",
                                   help="Click here to download the data as a CSV file")

            metric_columns = st.columns(2)
            with metric_columns[0]:
                st.subheader("TreeMap View")
                fig01 = px.treemap(selected_data_sorted, path=["Order_frequency"], values="Time(hrs)", hover_data=["Time(hrs)"],
                                   color="Order_frequency")
                fig01.update_layout(width=600, height=450)
                st.plotly_chart(fig01, use_container_width=True)

            with metric_columns[1]:
                st.subheader("Distribution of Number of Workers")
                fig = px.pie(selected_data_sorted, values="Number_of_workers",
                             names="Order_frequency", template="plotly_dark")
                fig.update_traces(
                    text=selected_data_sorted["Order_frequency"], textposition="inside")
                st.plotly_chart(fig, use_container_width=True)
            # else:
            #     st.write('<p style="font-weight:bold; font-size:24px; text-align:center;">Welcome, please select a zone you wish to explore and predict.</p>', unsafe_allow_html=True)


# Exploratory View
elif view == "Exploratory":
    with st.container():
        st.write("### Exploratory View")

        # Sidebar for exploratory controls
        menu = st.sidebar.selectbox(
            "Time Interval", ["Daily", "Weekly", "Monthly"])
        button_clicked = st.sidebar.button("Generate Exploratory Plots")

        metric_columns = st.columns(2)
        # Content for each exploratory menu option
        if button_clicked:
            generate_exploratory_plots(selected_data, menu)

        if selected_data is not None:

            # First Row plots:
            metric_columns = st.columns(2)
            with metric_columns[0]:
                selected_data_sorted = selected_data.sort_values(
                    by='Order_date')
                fig = px.scatter(selected_data_sorted, x='Total_Nb_Pallet', y='Time(hrs)',
                                 title='Association between Workload and Total number of pallets')
                st.plotly_chart(fig)
            with metric_columns[1]:
                selected_data_sorted = selected_data.sort_values(
                    by='Order_date')
                fig = px.scatter(selected_data_sorted, x='Nb_of_colli', y='Time(hrs)',
                                 title='Association between Workload and Total number of colli')
                st.plotly_chart(fig)

            # Second Row plots:
            # First Row: Metric Cards
            metric_columns = st.columns(2)
            with metric_columns[0]:
                selected_data_sorted = selected_data.sort_values(
                    by='Order_date')
                fig = px.line(selected_data_sorted, y='Total_Nb_Pallet', x='Order_date',
                              title='Distribution of the Total number of pallets')
                st.plotly_chart(fig)
            with metric_columns[1]:
                selected_data_sorted = selected_data.sort_values(
                    by='Order_date')
                fig = px.line(selected_data_sorted, y='Nb_of_colli', x='Order_date',
                              title='Distribution of number of colli')
                st.plotly_chart(fig)
# Prediction View
elif view == "Prediction":
    generate_prediction_page(selected_data)
